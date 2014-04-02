class WelcomeController < ApplicationController
  before_filter :authenticate_user!

  def index
		if current_user
			@budgets = current_user.budgets.includes(:categories).includes(:transactions)
		end
  end
end
