# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'click', '.transaction-remove-link', (event) ->
  id=$(this).attr("data-id")
  budget=$(this).attr("data-budget")
  tr = $(this).closest("tr")
  $.ajax "/budgets/"+budget+"/transactions/"+id,{
    cache:false
    ,dataType: "json"
    ,type: 'DELETE'
    ,success: (result) ->
      tr.remove()
    ,error: (result) ->
      console.log result
      $.bootstrapGrowl(result.responseText, {
        type: 'danger',
        ele: ".main-content"
        delay: 4000,
        align: 'center',
        offset:
          from: 'bottom',
          amount: 60
      })



  }