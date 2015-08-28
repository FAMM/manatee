# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'click', '.transaction-remove-link', (event) ->
  id=$(this).attr("data-id")
  budget=$(this).attr("data-budget")
  remove_element("/budgets/"+budget+"/transactions/"+id)
