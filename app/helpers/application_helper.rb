module ApplicationHelper
	def color_currency number
		css_class = ''
		
		if number >= 0
			css_class = 'positive'
		else
			css_class = 'negative'
		end
			
		"<span class=\"#{css_class}\">#{number_to_currency( number )}</span>".html_safe
	end
end
