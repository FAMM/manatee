
window.category_distribution_chart = (canvas,data) ->
  console.log($(canvas))
  ctx = $(canvas)[0].getContext('2d')
  new Chart(ctx).Doughnut(data)
