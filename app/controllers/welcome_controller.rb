class WelcomeController < ApplicationController
  before_filter :authenticate_user!

  def index
		if current_user
		  # fetch last 10 transactions
			@transactions = current_user.transactions.includes( :category ).limit(10)
			
			# fetch the categories for the sidebar
			@categories = current_user.categories.includes( :transactions )
			
			@sum_budget = 0.0
			@sum_budget_used = 0.0
			@categories.each do |category|
				@sum_budget += category.planned
				@sum_budget_used += category.used_this_month
			end
		end
  end
end
