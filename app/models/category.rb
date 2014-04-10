class Category < ActiveRecord::Base
  include HasUniqueColor

	belongs_to :budget
	has_many :transactions, dependent: :destroy

	attr_accessor :budget_used, :budget_used_by_date

	def self.find_by_name name
		where( name: name )
	end

	def used_this_month
    transactions.this_month.sum(:amount)
	end
end
