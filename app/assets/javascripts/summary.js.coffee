# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$().ready( () -> (
	$.each( $("tbody > tr.expandable"), () -> (
		setTreeView( $(this), 'hide' )
	) )
	$.each( $("tr[data-target]"), () -> (
		element = $(this)
		# add the click callback
		element.click( () -> (
		#	toggleTreePart( element )
			setTreeView( element, 'toggle', true )
		) )
	) )
) )

setTreeView = ( element, action, clicked=false ) -> (
	$.each( $( element.data('target') ), () -> (
		child = $(this)
	
		if action == 'toggle'
			if element.data('expanded')
				action = 'hide'
			else
				action = 'show'

		if child.hasClass('expandable')
			if action == 'show'
				if child.data('expanded')
					setTreeView( child, 'show' )
				else
					setTreeView( child, 'hide' )
			else
				setTreeView( child, 'hide' )
		
		if action == 'show'
			child.show('fast')		
		else
			child.hide('fast')
	) )

	# update the status of the container only if the user intentional clicked on the button
	# not when we call setTreeView recursive...
	if clicked
		if action == 'show'
			element.data( 'expanded', true )
		else
			element.data( 'expanded', false )
)
