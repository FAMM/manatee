module Haml::BudgetsHelper
	def budgetbar(budget, colorful=false, &block)
		color = 'info'

		if colorful
			if budget.used_this_month > budget.planned
				# make the bar read if no money left
				color = 'danger'
			elsif ( budget.used_this_month / budget.planned ) > 0.9
				# warn if more than 90% of the budget are used
				color = 'warning'
			end
		end

		capture_haml do
			haml_tag(
				'div',
				{
					'class' 				=> "progress-bar-#{color} progress-bar",
					'role' 					=> "progressbar",
					'aria-valuemin' => 0,
					'aria-valuemax' => budget.planned.to_i,
					'aria-valuenow' => budget.used_this_month.to_i,
					'style' 				=> "width: #{used_in_percent(budget.used_this_month, budget.planned)}%",
				},
				&block
			)
		end		
	end
end
