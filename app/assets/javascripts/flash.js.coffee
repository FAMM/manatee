# takes two strings, a message and a type
# type may be 'success', 'notice', 'error'
# if no type is given 'success' will be used
window.displayFlash = (message,type='success') -> (
	# clone the prototype flash
	flash = $('#flash-prototype').clone()
	# set the type
	flash.addClass( 'alert-' + type )
	# get the button
	button = flash.find('> button')
	# add the message, but keep the button
	flash.text( message )

	# hide the flash when the button is clicked
	button.click( () -> (
		flash.remove()
	) )
	# add the button to the flash
	flash.append( button )


	# make it visible
	flash.removeAttr('style')

	# display it
	$('#flash-container').append( flash )  

	return flash
)
