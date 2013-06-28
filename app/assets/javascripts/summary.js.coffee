# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

	$( 'form.filter-form' ).each( () -> (
		initializeFilterForm( $(this) )
	) )

	# allow the form container only to toggle when in phone mode
	$( 'form.filter-form legend' ).first().click( () -> (
		if window.responsive_design_awareness('phone')
				$( $(this).data('target') ).toggle()
	) )

	# make the filters collapsable if not in desktop mode
	unless window.responsive_design_awareness('desktop')
		$( $('form.filter-form legend').data('target') ).fadeOut()
) )

initializeFilterForm = ( element ) -> (
	# the change() function for 'select.column' and all other inputs are different
	# 'select.column' (needs also to update the inputs presented to the user)
	element.find( 'select.column' ).each( () -> (
		column_select = $(this)
		column_select.change( () -> (
			updateFilterFormColumn( column_select )
			updateFilterFormCondition( column_select )
		) )
		# set the initial value
		updateFilterFormColumn( column_select )
		updateFilterFormCondition( column_select )
	) )

	# other stuff
	element.find( 'select,input' ).each( () -> (
		# dont run on hidden inputs and on 'select.column' as it is already covered above
		unless $(this).attr('type') == 'hidden' && ( $(this).prop('tagName') == 'SELECT' && $(this).hasClass('column') )
			$(this).change( () -> (
				updateFilterFormCondition( $(this) )
			) )
	) )

	# make shit happen when you click the add button
	$('div#condition-new > button[type=button]').each( () -> (
		$(this).click( () -> (
			addFilterFormCondition( $(this) )
		) )
	) )
)

updateFilterFormColumn = ( element ) -> (
	selected = element.val()
	element.siblings().each( () -> (
		sibling = $(this)
		if sibling.hasClass( selected )
			sibling.show()
		else
			if sibling.prop('tagName') == 'DIV'
				sibling.hide()
	) )
)

removeFilterFormCondition = ( element ) -> (
	element.parent().remove()
)

addFilterFormCondition = ( element ) -> (
	# update the value
	updateFilterFormCondition( element )

	# get the 'id' of the condition
	number = $('div.conditions').first().data('count')
	
	# clone the stuff
	condition = $('div#condition-new').clone()
	console.log condition
	# replace all the attributes
	condition.attr( 'id', 'condition-' + number )
	condition.children().each( () -> (
					child = $(this)
					id = child.attr('id')
					if id
						child.attr( 'id', id.replace( 'new', number ) )

					if child.attr('type') == 'hidden'
						child.attr('name', 'filter[conditions][]')
	) )

	# freeze the column select (optional)
	condition.find( '> select.column' ).first().attr('disabled', 'disabled')

	# make the add button to a remove button
	button = condition.find('> button[type="button"]').first()
	button.attr( 'class', 'btn btn-mini' )
	button.text( button.data('remove') )
	button.click( () -> (
		removeFilterFormCondition( button )
	) )

	# redefine the handlers
	condition.find('> select.column').each( () -> (
		$(this).change( () -> (
			updateFilterFormColumn( $(this) )
			updateFilterFormCondition( $(this) )
		) )
	) )
	condition.find( 'select,input' ).each( () -> (
		# dont run on hidden inputs and on 'select.column' as it is already covered above
		unless $(this).attr('type') == 'hidden' && ( $(this).prop('tagName') == 'SELECT' && $(this).hasClass('column') )
			$(this).change( () -> (
				updateFilterFormCondition( $(this) )
			) )
	) )

	# increase the amount of conditions
	$('div.conditions').first().data('count', ( number + 1 ) )

	# add the stupid thing to the DOM tree
	$('div.conditions').append( condition )

	# highlight it so the user will know it was added
	condition.effect('highlight', 'slow')
)

window.updateFilterFormCondition = ( element ) -> (
	# find the div.conditon and get its id
	condition = element.parent()
	if condition.hasClass('condition-column')
		condition = condition.parent()

	# get the hidden element
	hidden = condition.find('> input[type="hidden"]').first()

	# construct the parsable data ( 'connector,column,operator,value' )
	connector = $( '#' + condition.attr('id') + '-connector' ).val()
	column = $( '#' + condition.attr('id') + '-column' ).val()
	operator = null
	value = null
	condition.find('> div.condition-column').each( () -> (
		condition_column = $(this)
		if condition_column.is(':visible')
			operator = condition_column.find('> select').first().val()
			value = condition_column.find('> input').first().val()
	) )

	hidden.val( [connector,column,operator,value] )
)


initializeTreeView = ( element ) -> (
	# find all the elements that should be hidden on start
	element.find( 'tr[data-tv-expanded=0]' ).each( () -> (
		setTreeViewItem( $(this), 'hide' )
	) )
)

window.allTreeView = ( action ) -> (
	containers = $( 'tr.treeview-container' )
	containers.each( () -> (
		container = $(this)
		if ( action == 'show' && container.data('tv-expanded') == 0 ) || ( action == 'hide' && container.data('tv-expanded') == 1 )
			container.click()
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

	# toggle the appearance of the sum of the transactions in the container
	sum_td = element.find('> td:last-child')
	if action == 'show'
		# hide the content
		sum_td.data( 'content', sum_td.text() )
		sum_td.text( '' )
	else
		# show the content
		sum_td.text( sum_td.data('content') )

	# update the status of the container only if the user intentional clicked on the button
	# not when we call setTreeView recursive...
	if clicked
		if action == 'show'
			element.data( 'tv-expanded', 1 )
		else
			element.data( 'tv-expanded', 0 )
)
