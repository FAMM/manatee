# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.category-remove-link', (event) ->
  id=$(this).attr("data-id")
  budget=$(this).attr("data-budget")
  remove_element("/budgets/"+budget+"/categories/"+id)


$(document).on 'click', '.category-edit-link', (event) ->
  id=$(this).attr("data-id")
  budget=$(this).attr("data-budget")
  name=$(this).attr("data-name")
  planned=$(this).attr("data-planned")

  form = $("#category-edit-form")
  form.find("#budget_id").val(budget)
  form.find("#category_id").val(id)
  form.find("#name").val(name)
  form.find("#planned").val(planned)

  $("#category-edit").show();

$(document).on 'click', '#category-save-edit', (event) ->
  form = $("#category-edit-form")
  budget = form.find("#budget_id").val()
  id = form.find("#category_id").val()
  name = form.find("#name").val()
  planned = form.find("#planned").val()

  data = {
    category: {
      name: name,
      planned: planned
    }
  }

  update_element("/budgets/"+budget+"/categories/"+id, data)
