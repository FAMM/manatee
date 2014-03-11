class SummariesController < ApplicationController
  before_filter :authenticate_user!

	def show
		@filter = Filter.new
		@filter.to_json( include: :conditions )

		transactions = current_user.transactions.with_filter @filter
		@summary, @sum = create_summary transactions
	end
 
	def create
		begin
			filter_options = JSON.parse( params[:filter][:raw].to_s )
		rescue JSON::ParserError
			filter_options = {}
		end

		filter_options["conditions"] ||= []

		# replace the hashes with real filter conditions
		filter_options["conditions"].map!{|c| FilterCondition.new c }
		
		@filter = Filter.new( filter_options )
		@filter.to_json( include: :conditions )

		transactions = current_user.transactions.with_filter @filter
		@summary, @sum = create_summary transactions

		render action: 'show'
	end

	private
		def create_summary transactions
			summary = {}
			sum = 0.0
			transactions.each do |transaction|
				# initalize the values for the structure
				summary[transaction.category] = {} if summary[transaction.category].nil?
				summary[transaction.category][transaction.date] = [] if summary[transaction.category][transaction.date].nil?
			
				# set the values
				summary[transaction.category][transaction.date] << transaction
				sum += transaction.amount
			
				# set category related stuff
				category = summary.keys[summary.keys.index(transaction.category)]
				category.budget_used = 0.0 if category.budget_used.nil?
				category.budget_used_by_date = {} if category.budget_used_by_date.nil?
				category.budget_used_by_date[transaction.date] = 0.0 if category.budget_used_by_date[transaction.date].nil?
				category.budget_used += transaction.amount
				category.budget_used_by_date[transaction.date] += transaction.amount
			end

			return [summary, sum]
		end
end
