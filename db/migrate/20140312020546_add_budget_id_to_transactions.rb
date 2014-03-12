class AddBudgetIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :budget_id, :integer
  end
end
