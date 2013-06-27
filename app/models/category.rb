class Category < ActiveRecord::Base
	belongs_to :user
	has_many :transactions

	attr_accessor :budget_used, :budget_used_by_date

	def saldo
		money_used = 0
		Category.transaction.each do |transaction|
			money_used += transaction.amount
		end

		saldo - money_used
	end
end
