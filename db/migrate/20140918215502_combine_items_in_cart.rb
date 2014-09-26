class CombineItemsInCart < ActiveRecord::Migration

  def up
    # replace multiple lines of the same product for a single line with increased quantity
    Cart.all.each do |cart|
      # count the number of each product in a cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove single item lines
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a single line x total quantity per product
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # replace single line of quantity x n for n x lines of quantity x 1
    Cart.all.each do |cart|
      # count the number of each product in a cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove multiple item lines
          cart.line_items.where(product_id: product_id).delete_all

          # replace with multiple lines of quantity x 1
          quantity.times do 
            item =cart.line_items.build(product_id: product_id)
            item.quantity = 1
            item.save!
          end
        end
      end
    end
  end
end
