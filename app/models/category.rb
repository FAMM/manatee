class Category < ActiveRecord::Base
	belongs_to :budget
	has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :budget }
  validates :planned, presence: true, numericality: true
  validates :budget_id, presence: true, numericality: :only_integer

	attr_accessor :budget_used, :budget_used_by_date

	def self.find_by_name name
		where( name: name )
	end

	def used_this_month
    transactions.this_month.sum(:amount)
	end
end
