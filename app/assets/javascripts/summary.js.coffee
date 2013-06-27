# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$().ready( () -> (
	$.each( $("tr[data-toggle=collapse]"), () -> (
		element = $(this)
		# hide everything
		#hideTreePart( element )
		# add the click callback
		#element.click( () -> (
		#	toggleTreePart( element )
		#) )
	) )
) )

showTreePart = ( element ) -> (
	setTreePart( element, 'show' )
)

hideTreePart = ( element ) -> (
	setTreePart( element, 'hide' )
)

toggleTreePart = ( element ) -> (
	if element.data('collapsed')
		action = 'hide'
	else
		action = 'show'

	setTreePart( element, action )
)

setTreePart = ( element, action ) -> (
	$.each( $( element.data( 'target' ) ), () -> (
		if action == 'show'
			$(this).show()
		else
			$(this).hide()
	) )

	if action == 'show'
		element.data('collapsed', true)
	else
		element.data('collapsed', false)
)
