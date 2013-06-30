class FilterCondition < ActiveRecord::Base
	belongs_to :filter
	after_initialize :fill_empty_attributes

	attr_accessor :raw

	def decode
		hash = {
			connector: self.connector,
			column: self.column,
			operator: self.operator,
			value: self.value
		}
		self.raw = hash.to_json
	end

	private
	def fill_empty_attributes
		# .first.first.first => look at Filter::COLUMNS, than it makes sense :P
		self.connector ||= Filter::CONNECTORS.first
		self.column ||= Filter::COLUMNS.first.first
		self.operator ||= Filter::COLUMNS.first.last.first
	end
end
