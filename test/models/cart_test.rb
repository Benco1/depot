require 'test_helper'


class CartTest < ActiveSupport::TestCase
  fixtures :products
  fixtures :carts 
  fixtures :line_items

  setup do
    @cart = Cart.create
    @book_1 = products(:rails)
    @book_2 = products(:ruby)
  end

  test "cart not nil" do
    assert_not_nil @cart, "cart must not be nil"
  end

  test "add a single product to the cart" do
    assert_difference('@cart.line_items.count', 1,
      'should increment line item') {
      @cart.add_product(@book_1.id).save! }
  end

  test "adding multiples of the same product" do
    2.times { @cart.add_product(@book_1.id).save! }
    item_1 = @cart.line_items.first
    
    assert_equal(2, item_1.quantity,'should yield correct quantity')
    
    assert_equal(2 * @book_1.price, item_1.total_price,
      'line total should be correct')
  end

  test "line item product_price assigned after adding product to cart" do
    @cart.add_product(@book_2.id).save!
    item_2 = @cart.line_items.find_by(product_id: @book_2.id)
    
    assert_equal(@book_2.price, item_2.product_price,
      'product_price should equal price of product' )
  end

  test "cart total price after adding two different products" do
      @cart.add_product(@book_1.id).save!
      @cart.add_product(@book_2.id).save!
      cart_total_price_expected = (@book_1.price + @book_2.price)

    assert_equal(cart_total_price_expected, @cart.total_price,
      'should yield correct cart total price')
  end


end
