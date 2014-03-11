class MoveCategoriesFromUsersToBudgets < ActiveRecord::Migration
  def change
    rename_column :categories, :user_id, :budget_id
  end
end
