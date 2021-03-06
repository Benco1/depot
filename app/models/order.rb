class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  # PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  belongs_to :pay_type

  validates :name, :address, :email, :pay_type_id, presence: true
  # validates :pay_type, inclusion: PAYMENT_TYPES


  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil # To avoid dependent destruction of line item(s)
      line_items << item # upon deletion of cart.
    end
  end
end
