class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 20, scale: 2
      t.string :comment
      t.decimal :saldo, precision: 20, scale: 2

      t.timestamps
    end
  end
end
