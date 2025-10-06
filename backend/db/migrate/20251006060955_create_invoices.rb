class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :order, null: false, foreign_key: true
      t.string :invoice_number, null: false
      t.date :date, null: false
      t.date :due_date
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :tax, precision: 10, scale: 2, default: 0
      t.decimal :total, precision: 10, scale: 2, null: false
      t.integer :status, default: 0
      t.text :notes

      t.timestamps
    end

    add_index :invoices, :invoice_number, unique: true
    add_index :invoices, :date
    add_index :invoices, :status
  end
end
