class Category < ActiveRecord::Base
	belongs_to :user
	has_many :transactions

	def saldo
		money_used = 0
		Category.transaction.each do |transaction|
			money_used += transaction.amount
		end

		saldo - money_used
	end

	def budget_used date=Date.today
		budget_used = 0.0

		start_date = date.beginning_of_month
		end_date = date.end_of_month

		Category.transactions.where( date: start_date..end_date ).each do |transaction|
						budget_used =+ transaction.amount
		end

		return budget_used
	end
end
