class AddDiscountCodeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :discount_code, foreign_key: true, null: true
    add_column :orders, :discount_amount, :decimal, precision: 10, scale: 2, default: 0
  end
end
