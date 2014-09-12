class StoreController < ApplicationController
  def index
    @products = Product.order(:title) # Alphabetical by title
  end
end
