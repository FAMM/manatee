window.responsive_design_awareness = (mode='determine') -> (
	if mode == 'determine'
		modes = ['phone', 'tablet', 'desktop']
		for mode in modes
			return mode if $( '#responsive_design_awareness > .visible-' + mode ).css('display') != 'none'
	else
		mode = $( '#responsive_design_awareness > .visible-' + mode ).css('display') != 'none'
)
