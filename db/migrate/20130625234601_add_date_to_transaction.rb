class AddDateToTransaction < ActiveRecord::Migration
  def change
					add_column :transactions, :date, :date
  end
end
