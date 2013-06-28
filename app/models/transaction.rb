class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :category

	def self.this_month
		between( Date.today.beginning_of_month, Date.today.end_of_month )
	end

	def self.between start_date, end_date
		where( date: start_date..end_date )
	end
end
