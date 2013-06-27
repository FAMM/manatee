class SummaryController < ApplicationController
  before_filter :authenticate_user!

  def index
					@categories = current_user.categories
					@saldo  = 0.0
					@categories.each do |category|
									category.budget_used = 0.0
									category.transactions.this_month.order("date ASC").each do |transaction|
													category.budget_used += transaction.amount
									end
									@saldo += category.budget_used
					end

  end
end
