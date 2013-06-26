class WelcomeController < ApplicationController
  before_filter :authenticate_user!

  def index
		if current_user
		  # fetch last 10 transactions
			@transactions = current_user.transactions.includes( :category ).limit(10)
			
			# fetch the categories for the sidebar
			@categories = current_user.categories
			
			@sum_budget = 0.0
			@sum_budget_used = 0.0
			@categories.each do |category|
				category.budget_used = 0.0
				category.transactions.where( date: Date.today.beginning_of_month..Date.today.end_of_month ).each do |transaction|
					 category.budget_used += transaction.amount
				end
				@sum_budget += category.budget
				@sum_budget_used += category.budget_used
			end
		end
  end
end
