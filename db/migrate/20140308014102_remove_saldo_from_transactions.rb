class RemoveSaldoFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :saldo, :decimal
  end
end
