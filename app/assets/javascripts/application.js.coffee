#= require jquery
#= require jquery_ujs
#= require jquery.ui.effect.all
#= require jquery.turbolinks
#= require turbolinks
#= require bootstrap
#= require lib/bootstrap-growl.min.js
#= require lib/bootstrap-datepicker.js
#= require_tree .

$(document).ready () ->
  $(".has-tooltip").tooltip()
  $("input[type=date]").datepicker({
    format: "mm-dd-yy"
  })

$(document).on "mouseover","tr.with-options", (event) ->
  $(this).find(".options").removeClass("hidden");

$(document).on "mouseout","tr.with-options", (event) ->
  $(this).find(".options").addClass("hidden");