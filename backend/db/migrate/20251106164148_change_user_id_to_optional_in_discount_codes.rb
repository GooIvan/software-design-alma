class ChangeUserIdToOptionalInDiscountCodes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :discount_codes, :user_id, true
  end
end
