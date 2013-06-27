$().ready( () -> (
	$( 'table.treeview' ).each( () -> (
		initializeTreeView( $(this) )
	) )
	$( 'tr[class="treeview-container"]' ).each( () -> (
		element = $(this)
		# add the click callback
		element.click( () -> (
		#	toggleTreePart( element )
			setTreeViewItem( element, 'toggle', true )
		) )
	) )
) )

initializeTreeView = ( element ) -> (
	# find all the elements that should be hidden on start
	element.find( 'tr[data-tv-expanded=0]' ).each( () -> (
		setTreeViewItem( $(this), 'hide' )
	) )
)

setTreeViewItem = ( element, action, clicked) -> (
	# find all the elements associated with the element clicked
	$( 'tr[class|=treeview][data-tv-parent="#' + element.attr('id') + '"]' ).each( () -> (
		child = $(this)
	
		if action == 'toggle'
			if element.data( 'tv-expanded' )
				action = 'hide'
			else
				action = 'show'

		if child.hasClass( 'treeview-container' )
			if action == 'show'
				if child.data('tv-expanded')
					setTreeViewItem( child, 'show' )
				else
					setTreeViewItem( child, 'hide' )
			else
				setTreeViewItem( child, 'hide' )
		
		if action == 'show'
			child.show()		
		else
			child.hide()
	) )

	# update the status of the container only if the user intentional clicked on the button
	# not when we call setTreeView recursive...
	if clicked
		if action == 'show'
			element.data( 'tv-expanded', 1 )
		else
			element.data( 'tv-expanded', 0 )
)

