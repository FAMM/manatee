class Filter < ActiveRecord::Base
	after_initialize :fill_empty_attributes
	attr_accessor :start_date, :end_date, :conditions, :reset

	CONNECTORS = ['and', 'or']
	COLUMNS = {
		amount: ['==', '!=', '<', '>', '>=', '<='],
		comment: ['==', '!='],
		category: ['==', '!=']
	}

	def fill_empty_attributes
		if self.reset
			self.start_date = Date.today.beginning_of_month
			self.end_date = Date.today.end_of_month
			self.conditions = Array.new
		else
			self.start_date ||= Date.today.beginning_of_month
			self.end_date ||= Date.today.end_of_month
			self.conditions ||= Array.new
		end
	end

	def persisted?
		false
	end
end
