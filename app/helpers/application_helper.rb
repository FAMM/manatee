module ApplicationHelper
				def formated_currency *args
								currency = number_to_currency *args

								"<span=\"currency\">#{currency}</span>".html_safe
				end
end
