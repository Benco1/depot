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

end
