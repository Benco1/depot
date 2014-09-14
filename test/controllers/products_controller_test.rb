require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @products = Product.all
    @update = {
      title: 'Lorem Ipsum',
      description: 'Wibbles are fun!',
      image_url: 'image.jpg',
      price: 19.99
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "index should include the correct number of products" do
    get :index
    assert_select 'tr', @products.count
  end
  
  test "index should include Show/Edit/Delete actions" do
    %w(Show Edit Destroy).each do |list_action|
      get :index
      assert_select '.list_actions a', "#{list_action}"
    end
  end
  
  test "index should include the correct product titles" do
    get :index
    @products.each do |product|
      assert_select 'dt', "#{product.title}"
    end
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end

end
