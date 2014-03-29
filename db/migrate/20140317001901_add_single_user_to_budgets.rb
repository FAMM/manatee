class AddSingleUserToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :single_user, :boolean, :default => false
  end
end
