class WelcomeController < ApplicationController
  def index
		if current_user
		  @transactions = current_user.transactions.include( :categories ).limit(10)
		end
  end
end
