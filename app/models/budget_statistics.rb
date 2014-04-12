class BudgetStatistics
  attr_accessor :budget

  def initialize(budget)
    @budget=budget
  end

  def category_distribution
    @budget.categories.map {|category| {:value => category.used_this_month.to_i, :color => category.color} }
  end

  def monthly_trend
    days = (1..Date.today.day).to_a
    data = calculate_monthly_trend(days)

    {
        labels: days,
        datasets: [{
          fillColor: "rgba(220,220,220,0.5)",
          strokeColor: "rgba(220,220,220,1)",
          pointColor: "rgba(220,220,220,1)",
          pointStrokeColor: "#fff",
          data: data
        }]
    }
  end


  private

  def calculate_monthly_trend(days)
    transactions_grouped_by_day = @budget.transactions.this_month.group_by {|t| t.date.day}
    current_value = 0
    data = []

    days.each do |day|
      current_value += transactions_grouped_by_day[day].sum(&:amount).to_i if transactions_grouped_by_day.keys.include?(day)
      data << current_value
    end

    data
  end

end