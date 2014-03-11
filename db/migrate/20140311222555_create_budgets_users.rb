class CreateBudgetsUsers < ActiveRecord::Migration
  def change
    create_table :budgets_users do |t|
      t.integer :user_id
      t.integer :budget_id

      t.timestamps
    end
  end
end
