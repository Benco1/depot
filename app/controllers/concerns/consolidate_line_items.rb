module ConsolidateLineItems
  extend ActiveSupport::Concern

  private

    def consolidate_line_items_by_quantity

      Cart.all.each do |cart|
        
        cart.line_items.each_with_object({}) do |line, h|
          h[line.product_id] = line.quantity

          h.each do |prod_id, quantity|

              cart.line_items.where('product_id = ? and quantity > ?', prod_id, 1).each do |extra_line|
                extra_line.destroy
              end
            end

            LineItem.create(cart_id: cart.id, product_id: prod_id, quantity: quantity)

          end
        end
      end
    end
end