class SummariesController < ApplicationController
  before_filter :authenticate_user!

  def index
		@filter = Filter.new
		@filter.to_json( include: :conditions )

		@categories = current_user.categories
		@saldo  = 0.0
		@categories.each do |category|
			category.budget_used_by_date = Hash.new
			category.budget_used_by_date.default = 0.0
			category.budget_used = 0.0
			category.transactions.this_month.order("date ASC").each do |transaction|
				category.budget_used += transaction.amount
				category.budget_used_by_date[transaction.date] += transaction.amount
			end
			@saldo += category.budget_used
		end
  end

	# send the options for the filter as json string is "id"
	def show
		p params[:id]
		begin
			filter_options = JSON.parse( params[:id] )
		rescue JSON::ParserError
			filter_options = {}
		end
		@filter = Filter.new( filter_options )
		@filter.to_json( include: :conditions )

		render action: 'index'
	end
end
