class StoreController < ApplicationController
  def index
    @products = Product.order(:title) # All products, alphabetical by title
  end
end
