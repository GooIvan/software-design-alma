class CreateDiscountCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :discount_codes do |t|
      t.string :code
      t.string :discount_type
      t.decimal :value
      t.integer :max_uses
      t.integer :max_uses_per_user
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :active
      t.references :user, null: false, foreign_key: true
      t.integer :created_by_id

      t.timestamps
    end
    add_index :discount_codes, :code
  end
end
