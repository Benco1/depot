require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index

    products = Product.all

    assert_response :success
    assert_select '#columns #side a', minimum: 4
    assert_select '#main .entry', products.count
    assert_select '.price', /\$[,\d]+\.\d\d/
    products.each do |product|
      assert_select 'h3', "#{product.title}"
    end
  end

  test "markup needed for store coffeescript" do
    get :index
    assert_select '.store .entry > img', 4
    assert_select '.entry input[type=submit]', 4
  end

end
