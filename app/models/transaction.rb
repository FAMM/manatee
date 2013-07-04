class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :category

	def self.this_month
		between( Date.today.beginning_of_month, Date.today.end_of_month )
	end

	def self.between start_date, end_date
		where( date: start_date..end_date )
	end

	def self.with_filter filter
		query = ''
		query << 'date >= :start_date ' if filter.start_date
		query << 'AND ' unless query.empty?
		query << 'date <= :end_date ' if filter.end_date

		replacements = {
			start_date: filter.start_date,
			end_date: filter.end_date,
		}

		i = 0
		filter.conditions.each do |condition|
			# user query_condition to store the query for each condition
			query_condition = ''
			## validate the filter
			# is the connector valid?
			if Filter::CONNECTORS.include?( condition.connector )
				query_condition << "#{condition.connector.upcase} " unless query.empty?
	
				# are the column and operator valid?
				if Filter::COLUMNS.keys.include?( condition.column.to_sym ) && Filter::COLUMNS[condition.column.to_sym].include?( condition.operator )
					# the condition column needs some extra treatment
					if condition.column == 'category'
						query_condition << %Q!category_id #{condition.operator} :#{condition.column}_#{i}!
						condition.value = condition.value.to_i
					else
						query_condition << %Q!#{condition.column} #{condition.operator} :#{condition.column}_#{i} !
					end

					query << query_condition
					key = "#{condition.column}_#{i}".to_sym
					replacements[key] = condition.value
				else
					logger.debug "Wrong column and/ or operator: #{condition.column}/ #{condition.operator}"
				end
			else
				logger.debug "Wrong connector: #{condition.connector}"
			end
		end

		logger.debug query
		logger.debug replacements

		where( query, replacements )
	end
end
