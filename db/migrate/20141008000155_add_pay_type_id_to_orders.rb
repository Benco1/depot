class AddPayTypeIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pay_type_id, :integer, default: 1
  end
end
