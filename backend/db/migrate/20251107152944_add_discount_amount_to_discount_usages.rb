class AddDiscountAmountToDiscountUsages < ActiveRecord::Migration[8.0]
  def change
    add_column :discount_usages, :discount_amount, :decimal, precision: 10, scale: 2, default: 0
  end
end
