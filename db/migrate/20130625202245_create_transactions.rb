class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 20, scale: 2, default: 0.0
      t.string :comment
      t.date :date

      t.integer :user_id
      t.integer :category_id
      t.integer :budget_id

      t.timestamps
    end
  end
end
