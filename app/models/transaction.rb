class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :category

	def self.this_month
		where( date: Date.today.beginning_of_month..Date.today.end_of_month )
	end
end
