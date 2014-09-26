class AddProductPriceToLineItem < ActiveRecord::Migration
  
  class LineItem < ActiveRecord::Base
    belongs_to :product
    belongs_to :cart
  end

  def up
    # copy over product prices to new column to record the
    # list price at the time of offer/sale
    add_column :line_items, :product_price, :decimal, precision: 8, scale: 2

    LineItem.all.each do |item|
      item.product_price = item.product.price
      item.save!
    end

  end

  def down

    remove_column :line_items, :product_price

  end
end
