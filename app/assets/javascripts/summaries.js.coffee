# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

####
# Run whenever the page is loaded
####
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

	initializeFilterForm()

	# allow the form container only to toggle when in phone mode
	$( '#filter-heading' ).click( () -> (
		$( $(this).data('target') ).toggle()
	) )

	# hide the filters by default
	$('#filter-heading').click()
) )

####
# FilterForm
####

# initialize, hook up all the onChange methode
initializeFilterForm = () -> (
	filterform = $('form.filter-form')
	condition_new = $('#condition-new')

	## the change() function for 'select.condition-column' and all other inputs are different
	## 'select.condition-column' (needs also to update the inputs presented to the user)
	filterform.find( 'select.condition-column' ).each( () -> (
		column_select = $(this)
		column_select.change( () -> (
			updateFilterFormConditionColumn( condition_new )
			updateFilterFormCondition( condition_new )
		) )
		
		# set the initial value
		loadFilterFormConditions()
	) )

	## other inputs
	filterform.find( 'select,input' ).each( () -> (
		# dont run on hidden inputs and on 'select.condition-column' as it is already covered above
		unless $(this).attr('type') == 'hidden' && ( $(this).prop('tagName') == 'SELECT' && $(this).hasClass('column') )
			$(this).change( () -> (
				updateFilterFormCondition( condition_new )
			) )
	) )

	## load all the filters from the server
	fetchFilters()

	## strip the 'name' attribute, if does not start with raw_
	filterform.find( '[name]' ).each( () -> (
		unless $(this).attr( 'name' ).match( /^raw_/ )
			$(this).removeAttr( 'name' )
	) )

	## make shit happen when you click the add button
	$('div#condition-new > button[type=button]').click( () -> (
		addFilterFormCondition()
	) )

	## when clicking on load, load the currently selected thingy
	$('#load-filter').click( () -> (
		loadFilter( $('#filter').val() )
	) )

	## hide the unneeded column options
	updateFilterFormConditionColumn( condition_new )

	return true
)

# fetch all the filters from the server
fetchFilters = () -> (
	$.getJSON( '/filters.json', (filters) -> (
		for filter in filters
			option = $('<option></option>')
			option.val( JSON.stringify( filter ) )
			option.text( filter.name )
			$('#filter').append( option )
	) )
)

# show the divs which corrospond to the selected column
updateFilterFormConditionColumn = ( condition ) -> (
	column_select = condition.find( '> select.condition-column' )
	## get the current value of the select.condition-column
	selected = column_select.val()
	## check all the siblings
	column_select.siblings().each( () -> (
		sibling = $(this)
		if sibling.hasClass( selected )
			sibling.show()
		else if sibling.hasClass( 'condition-column' )
			sibling.hide()
	) )

	return condition
)

# remove a FilterCondition
removeFilterFormCondition = ( condition ) -> (
	$( '#br-' + condition.attr('id') ).remove()
	condition.remove()

	return condition
)

# add a FilterCondition and fill it with values from the 'new' section, and load the default values to the form
addFilterFormCondition = () -> (
	## make sure the condition is updated
	updateFilterFormCondition( $('#condition-new') )

	## clone the stuff
	condition = $('#condition-new').clone()
	
	## get the 'id' of the condition
	number = $('div.conditions').first().data('count')
	
	## replace the new with the number in all IDs
	condition.attr( 'id', 'condition-' + number )
	condition.children().each( () -> (
					child = $(this)
					# reset the ids of the elements
					id = child.attr('id')
					if id # if the element has an ID
						child.attr( 'id', id.replace( 'new', number ) )
	) )

	## freeze the column select (optional)
	condition.find( 'select.condition-column' ).first().attr('disabled', 'disabled')

	## make the add button to a remove button
	button = condition.find('button[type="button"]').first()
	button.attr( 'class', 'btn' )
	button.text( button.data('remove') )
	button.click( () -> (
		removeFilterFormCondition( condition )
	) )

	## redefine the handlers
	condition.find('select.condition-column').each( () -> (
		$(this).change( () -> (
			updateFilterFormConditionColumn( condition )
			updateFilterFormCondition( condition )
		) )
	) )
	condition.find( 'select,input' ).each( () -> (
		# dont run on hidden inputs and on 'select.condition-column' as it is already covered above
		unless $(this).attr('type') == 'hidden' && ( $(this).prop('tagName') == 'SELECT' && $(this).hasClass('column') )
			$(this).change( () -> (
				updateFilterFormCondition( condition )
			) )
	) )

	## increase the amount of conditions
	$('div.conditions').first().data('count', ( number + 1 ) )

	## add the new condition to the DOM tree
	$('div.conditions').append( '<br id="br-condition-' + number + '">' )
	$('div.conditions').append( condition )

	## reset the attributes on the 'condition-new' inputs, but spare the hidden ones (they get updated via the updateFilterFormCondition)
	condition_new = $('#condition-new')
	for child in condition_new.children()
		unless $(child).attr( 'type' ) == 'hidden'
			$(child).val( $(child).data( 'default' ) )
	# update it so it also affects the hidden inputs
	updateFilterFormCondition( condition_new )

	# hide the unneeded columns
	updateFilterFormConditionColumn( condition_new )

	# highlight it so the user will know it was added
	#condition.effect('highlight', 'slow')

	return condition
)

updateFilterFormCondition = ( condition ) -> (
	# get the values to encode
	connector = $( '#' + condition.attr('id') + '-connector' ).val()
	column = $( '#' + condition.attr('id') + '-column' ).val()
	operator = null
	value = null
	condition.find('div.condition-column').each( () -> (
		condition_column = $(this)
		if condition_column.is(':visible')
			operator = condition_column.find('select.condition-operator').first().val()
			value = condition_column.find('input.condition-value').first().val()
	) )

	# set the values
	condition.find('input[type="hidden"].condition-connector').first().val( connector )
	condition.find('input[type="hidden"].condition-column').first().val( column )
	condition.find('input[type="hidden"].condition-operator').first().val( operator )
	condition.find('input[type="hidden"].condition-value').first().val( value )

	return condition
)

loadFilterFormConditions = () -> (
	# delete all the old conditions
	old_conditions = $('div.conditions').children()

	for old_condition in old_conditions
		unless $(old_condition).attr('id') == 'condition-new'
			$(old_condition).remove()

	conditions_json = $('#raw_conditions').val()
	conditions = JSON.parse( conditions_json )

	for condition in conditions
		# create a new condition
		condition_html = addFilterFormCondition()
		
		# set the values
		condition_html.find('select.condition-connector').first().val( condition.connector )
		condition_html.find('select.condition-column').first().val( condition.column )
		condition_html.find('select.condition-operator').first().val( condition.operator )
		condition_html.find('input[type="text"].condition-value').first().val( condition.value )

		# apply the values also to the hidden inputs
		updateFilterFormCondition( condition_html )

		# hide the unnneeded column options
		updateFilterFormConditionColumn( condition_html )

	return true
)

loadFilter = ( filter_json ) -> (
	# write the data
	$('#filter_raw').val( filter_json )
	filter = JSON.parse( filter_json )

	# set the name
	$('#raw_name').val( filter.name )
	
	# set start and end date
	$('#raw_start_date').val( filter.start_date )
	$('#raw_end_date').val( filter.end_date )

	# load the conditions
	$('#raw_conditions').val( JSON.stringify( filter.conditions ) )
	loadFilterFormConditions()

	return true
)

saveFilter = () -> (
	
	raw = new Object
	# collect the attributes
	raw.start_date = $('#raw_start_date').val()
	raw.end_date = $('#raw_end_date').val()
	raw.name = $('#raw_name').val()
	raw.conditions = JSON.parse( $('#raw_conditions').val() )

	# create a JSON string
	json = JSON.stringify( raw )

	# send it to the server
	$.ajax(
		{
			url: '/filters'
		}
	)

	return false
)

deleteFilter = () -> (
	'asdf'
	return false
)

####
# TreeView stuff
####
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
