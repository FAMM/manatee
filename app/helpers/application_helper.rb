module ApplicationHelper
	def color_currency number
		css_class = ''
		sign = ''
		
		if number > 0
			css_class = 'positive'
			sign = '+'
		elsif number = 0
		  css_class = 'neutral'
			sign = '&plusmn;'.html_safe
		else
			css_class = 'negative'
			sign = '-'
		end
			
		"<span class=\"#{css_class}\">#{sign}#{number_to_currency( number )}</span>".html_safe
	end
end
