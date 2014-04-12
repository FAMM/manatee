setup_responsive_chart = (type,container,data) ->
  canvas = $(container)
  newWidth = canvas.parent().width()
  canvas.prop
    width: newWidth
    height: 300
  ctx = canvas.get(0).getContext("2d")

  switch (type.toLowerCase())
    when "line" then new Chart(ctx).Line data
    when "doughnut" then new Chart(ctx).Doughnut data


window.responsive_chart = (type,container,data) ->
  setup_responsive_chart(type,container,data)
  $(window).resize () ->
    setup_responsive_chart(type,container,data)
