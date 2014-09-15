class StoreController < ApplicationController
  def index
    @products = Product.order(:title) # All products, alphabetical by title
    if session[:count].nil?
      session[:count] = 1
    else
      session[:count] += 1
    end
  end
end



