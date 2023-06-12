class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :cpf
      t.belongs_to :region, null: false, foreign_key: true
      t.belongs_to :agency, null: false, foreign_key: true
      t.integer :balance
      t.string :status

      t.timestamps
    end
  end
end
