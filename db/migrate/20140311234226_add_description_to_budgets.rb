class AddDescriptionToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :description, :text
  end
end
