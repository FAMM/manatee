class AddCurrencyColumnToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :currency, :string, default: "€"
  end
end
