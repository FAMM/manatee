class Filter < ActiveRecord::Base
	after_initialize :set_default_attributes

	attr_accessor :raw

	belongs_to :user
	has_many :conditions, class_name: 'FilterCondition'

	validates :name, presence: true, uniqueness: true

	CONNECTORS = ['and', 'or']
	COLUMNS = {
		amount: ['=', '<>', '<', '>', '>=', '<='],
		comment: ['=', '<>'],
		category: ['=', '<>']
	}

	def set_default_attributes
		self.start_date ||= Date.today.beginning_of_month
		self.end_date ||= Date.today.end_of_month
	end
end
