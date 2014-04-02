#= require jquery
#= require jquery_ujs
#= require jquery.ui.effect.all
#= require jquery.turbolinks
#= require turbolinks
#= require bootstrap
#= require lib/bootstrap-growl.min.js
#= require_tree .

$(document).on "mouseover","tr.with-options", (event) ->
  $(this).find(".options").removeClass("hidden");

$(document).on "mouseout","tr.with-options", (event) ->
  $(this).find(".options").addClass("hidden");