class RenameCategoryBudgetColumnToPlaned < ActiveRecord::Migration
  def change
    rename_column :categories, :budget, :planed
  end
end
