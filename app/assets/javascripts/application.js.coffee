#= require jquery
#= require jquery_ujs
#= require jquery.turbolinks
#= require turbolinks
#= require bootstrap
#= require_tree .

#require jquery.ui.effect.all

$(document).ready () ->
  $(".has-tooltip").tooltip()
  $("input[type=date]").datepicker({
    format: "yyyy-mm-dd"
  })

$(document).on "mouseover",".with-options", (event) ->
  $(this).find(".options").removeClass("hidden");

$(document).on "mouseout",".with-options", (event) ->
  $(this).find(".options").addClass("hidden");



window.show_error_message= (text) ->
  $.bootstrapGrowl(text, {
    type: 'danger',
    ele: ".main-content"
    align: 'center',
    offset:
      from: 'bottom',
      amount: 60
  })
