class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :value
      t.string :transaction_type
      t.string :event

      t.timestamps
    end
  end
end
