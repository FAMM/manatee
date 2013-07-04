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
	
	$( 'tr[class~="treeview-container"]' ).each( () -> (
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

	## strip the name attribute from every input besides the hidden inputs needed
	for input in filterform.find( 'select,input' )
		unless ( $(input).attr('id') == 'filter_raw' ) || ( $(input).attr('name') == 'utf8' ) || ( $(input).attr('name') == 'authenticity_token' ) 
			$(input).removeAttr('name')

	## load all the filters from the server
	fetchFilters()

	## bring some actions to the buttons
	# add button
	$('div#condition-new > button[type=button]').click( () -> (
		addFilterFormCondition()
	) )

	# load button
	$('#filter-load').click( () -> (
		loadFilter( $('#filter').val() )
	) )
	# save button
	$('#filter-save').click( () -> (
		saveFilter()
	) )
	# delete button
	$('#filter-delete').click( () -> (
		deleteFilter()
	) )
	# apply button
	$('#filter-apply').click( () -> (
		applyFilter()
	) )
	# reset button
	$('#filter-reset').click( () -> (
		resetFilter()
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
	## check all the
	for child in condition.find('> div.condition-column')
		if $(child).hasClass( condition.find( '> select.condition-column' ).val() )
			$(child).css('display', 'inline-block')
		else if $(child).hasClass( 'condition-column' )
			$(child).css('display', 'none')

	return condition
)

# remove a FilterCondition
removeFilterFormCondition = ( condition ) -> (
	$( '#br-' + condition.attr('id') ).remove()
	condition.remove()

	updateFilterFormConditions()

	return condition
)

# add a FilterCondition and fill it with values from the 'new' section, and load the default values to the form
addFilterFormCondition = () -> (
	## make sure the condition is updated
	updateFilterFormCondition( $('#condition-new') )

	## clone the stuff
	condition_new = $('#condition-new')
	condition = condition_new.clone()
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
		unless $(this).attr('type') == 'hidden' || ( $(this).prop('tagName') == 'SELECT' && $(this).hasClass('column') )
			$(this).change( () -> (
				updateFilterFormCondition( condition )
			) )
	) )

	## increase the amount of conditions
	$('div.conditions').first().data('count', ( number + 1 ) )

	## add the new condition to the DOM tree
	$('div.conditions').append( '<br id="br-condition-' + number + '">' )
	$('div.conditions').append( condition )

	## get the selected values (clone() does not copy the currently selected element in a select)
	condition.find('select.condition-connector').val( condition_new.find('select.condition-connector').val())
	condition.find('select.condition-column').val( condition_new.find('select.condition-column').val())
	condition.find('select.condition-operator').val( condition_new.find('select.condition-operator').val())
	condition.find('select.condition-value').val( condition_new.find('select.condition-value').val())
	
	## update the columns
	updateFilterFormConditionColumn( condition )

	## reset the attributes on the 'condition-new' inputs, but spare the hidden ones (they get updated via the updateFilterFormCondition)
	for child in condition_new.find('select,input')
		unless $(child).attr( 'type' ) == 'hidden'
			$(child).val( $(child).data( 'default' ) )
		# reset even the json object
		if $(child).hasClass( 'condition-json' )
			$(child).val( '' )
	# update it so it also affects the hidden inputs
	updateFilterFormCondition( condition_new )

	# hide the unneeded columns
	updateFilterFormConditionColumn( condition_new )

	# highlight it so the user will know it was added
	#condition.effect('highlight', 'slow')

	return condition
)

updateFilterFormConditions = () -> (
	# update the raw-conditions json field (collection of all conditions)
	raw_conditions = '['
	for raw_condition in $('input[type="hidden"].condition-json')
		unless $(raw_condition).attr('id') == 'condition-new-json'
			raw_conditions += $(raw_condition).val()
			raw_conditions += ','

	# remove the last ,
	raw_conditions = raw_conditions.slice(0,-1) unless raw_conditions == '['

	raw_conditions += ']'
	$('#raw_conditions').val( raw_conditions )
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
			value = condition_column.find('input.condition-value,select.condition-value').first().val()
	) )

	# set the values
	condition.find('input[type="hidden"].condition-connector').first().val( connector )
	condition.find('input[type="hidden"].condition-column').first().val( column )
	condition.find('input[type="hidden"].condition-operator').first().val( operator )
	condition.find('input[type="hidden"].condition-value').first().val( value )

	json = new Object
	json.connector = connector
	json.column = column
	json.operator = operator
	json.value = value
	condition.find('input[type="hidden"].condition-json').first().val( JSON.stringify( json ) )

	updateFilterFormConditions()

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
		condition_html.find('input[type="text"].condition-value,select.condition-value').first().val( condition.value )

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

	# set the id
	$('#raw_id').val( filter.id )

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
	raw.id = $('#raw_id').val()
	raw.start_date = $('#raw_start_date').val()
	raw.end_date = $('#raw_end_date').val()
	raw.name = $('#raw_name').val()
	raw.conditions = JSON.parse( $('#raw_conditions').val() )

	# create a JSON string
	json = JSON.stringify( raw )

	# if there is an id, update the filter, otherwise create a new one
	if raw.id
		$.ajax(
			{
				type: "PUT",
				url: '/filters/' + raw.id + '.json',
				data: { filter: { raw: json } },
				dataType: 'json',
				success: (data) -> (
					alert 'success'
					console.log data
				),
				fail: (data) -> (
					alert 'failure'
					console.log data
				)
			}
		)
	else
		$.ajax(
			{
				type: "POST",
				url: '/filters.json',
				data: { filter: { raw: json } },
				dataType: 'json',
				success: (data) -> (
					alert 'success'
					console.log data
				),
				fail: (data) -> (
					alert 'failure'
					console.log data
				)
			}
		)

	return true
)

deleteFilter = () -> (
	json = JSON.parse( $('#filter').val() )
	$.ajax( {
		type: "DELETE",
		url: '/filters/' + json.id  + '.json',
		dataType: 'json',
		success: (data) -> (
			alert 'success'
			console.log data
		),
		fail: (data) -> (
			alert 'failure'
			console.log data
		)
		}
	)
	
	return true
)

applyFilter = () -> (
	# build the raw-json-filter
	filter = new Object
	# collect the attributes
	filter.id = $('raw_id').val()
	filter.start_date = $('#raw_start_date').val()
	filter.end_date = $('#raw_end_date').val()
	filter.name = $('#raw_name').val()
	filter.conditions = JSON.parse( $('#raw_conditions').val() )

	# create a JSON string
	json = JSON.stringify( filter )

	# write the value
	$('#filter_raw').val( json )

	$('form.filter-form').submit()
)

resetFilter = () -> (
	$('#filter_raw').val( '{}' )
	$('form.filter-form').submit()
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
