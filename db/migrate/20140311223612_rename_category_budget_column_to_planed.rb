class RenameCategoryBudgetColumnToPlaned < ActiveRecord::Migration
  def change
    rename_column :categories, :budgets, :planned
  end
end
