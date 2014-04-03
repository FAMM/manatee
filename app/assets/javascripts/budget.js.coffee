# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


get_budget_user_ids = () ->
  $("#budget_user_id_list").val().split(",")

set_budget_user_ids = (user_ids) ->
  $("#budget_user_id_list").val(user_ids.join(","))

add_user_to_budget = (user)->
  user_ids= get_budget_user_ids()
  user_ids.push(user.id.toString())
  set_budget_user_ids(user_ids)
  badge = "<span class='badge'>#{user.name} <a href='javascript:void(0)' class='budget-user-remove-link' data-user='#{user.id}'><i class='glyphicon glyphicon-remove'></i></a></span>"
  $(".user-badges").html($(".user-badges").html()+badge)






# remove selected user from the budget user list
$(document).on 'click', '.budget-user-remove-link', (event) ->
  user_id = $(this).attr('data-user')
  user_ids = get_budget_user_ids()

  index = user_ids.indexOf(user_id)
  if user_id then user_ids.splice(index,1)
  set_budget_user_ids(user_ids)

  $(this).closest(".badge").remove()



$(document).on 'click', '#add-budget-user-button', (event) ->
  text_field = $("#new_user_identifier")
  identifier = text_field.val()

  if identifier is null then show_error_message("You enter a name or an email adress"); return

  $.getJSON("/users/by_identifier/"+identifier)
    .success (user) ->
      if user is null
        show_error_message("Can't find user")
      else
        user_ids = get_budget_user_ids()
        if user_ids.indexOf(user.id.toString())
          add_user_to_budget(user)
          text_field.val("")
        else
          show_error_message("User already added")









