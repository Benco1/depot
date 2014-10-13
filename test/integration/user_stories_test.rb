require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest

  fixtures :products

# Story: A user goes to the store index page. They select a product, adding it to their cart.
# They then check out, filling in their details on the checkout form. When they submit,
# an order is created in the database containing their information, along with a single
# line item corresponding to the product they added to their cart. Once the order has
# been received, an email is sent confirming their purchase.

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # Step 1: A user goes to the store index page.
    # [ Here, the URL is specified with request. This differs from functional
    # testing of controllers, which would just identify the action. ]
    get "/"                  
    assert_response :success
    assert_template "index"

    # Step 2: They select a product, adding it to their cart.
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # Step 3: They then check out.
    get "/orders/new"
    assert :success
    assert_template "new"

    post_via_redirect "/orders",
                      order: { name:        "Bill Smith",
                               address:     "1 Main Street",
                               email:       "billy@example.com",
                               pay_type_id: 1
                             }
    assert :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Bill Smith", order.name
    assert_equal "1 Main Street", order.address
    assert_equal "billy@example.com", order.email
    assert_equal 1, order.pay_type_id

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["billy@example.com"], mail.to
    assert_equal "PragmaticStore@example.com", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "shipped order email" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"                  
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    get "/orders/new"

    post_via_redirect "/orders",
                      order: { name:        "Bill Smith",
                               address:     "1 Main Street",
                               email:       "billy@example.com",
                               pay_type_id: 1
                             }
    assert :success

    orders = Order.all
    order = orders[0]

    patch_via_redirect order_url(order.id), { order: { ship_date:   "2014-10-10" } }

    assert :success

    orders = Order.all
    order = orders[0]

    assert_equal "2014-10-10", order.ship_date.to_s

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["billy@example.com"], mail.to
    assert_equal "PragmaticStore@example.com", mail[:from].value
    assert_equal "Pragmatic Store Order Shipped", mail.subject
  end

  test "user inputs invalid cart id" do
    get '/carts'
    assert :success
    assert_template "index"

    get '/carts/invalid_id_value'
    assert_redirected_to store_url

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["admin@example.com"], mail.to
    assert_equal "PragmaticStore@example.com", mail[:from].value
    assert_equal "Pragmatic Store Error Notification", mail.subject
  end
end
