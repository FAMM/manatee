class WelcomeController < ApplicationController
  def index
		if current_user
		  # fetch last 10 transactions
			@transactions = current_user.transactions.includes( :category ).limit(10)
			
			# fetch the categories for the sidebar
			@categories = current_user.categories
			@saldo = current_user.saldo
			@old_saldo = current_user.saldo( Date.today.beginning_of_month - 1.day )
		end
  end
end
