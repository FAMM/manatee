class Category < ActiveRecord::Base
	belongs_to :user
	has_many :transactions, dependent: :delete_all

	attr_accessor :budget_used, :budget_used_by_date

	def self.find_by_name name
		where( name: name )
	end
end
