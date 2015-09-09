class AddCreatorIdToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :creator_id, :integer, null: false
  end
end
