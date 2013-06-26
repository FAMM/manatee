class WelcomeController < ApplicationController
  def index
		if current_user
		  @transactions = current_user.transactions.include( :categories ).limit(10)
			@categories = current_user.categories
			@saldo = current_user.saldo
			@old_saldo = current_user.saldo( Date.today.beginning_of_month - 1.day )
		end
  end
end
