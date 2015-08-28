class BudgetStatistics
  attr_accessor :budget

  COLORS = ["#00A0B0", "#6A4A3C", "#CC333F", "#EB6841", "#EDC951"]
  def get_color(i)
    COLORS[i]
  end

  def initialize(budget)
    @budget=budget
  end

  def category_distribution
    @budget.categories.map {|category| {:value => category.used_this_month.to_i, :color => category.color} }
  end

  def user_distribution
    @budget.users.each_with_index.map {|user,i| {:value => calculate_user_amount(user).to_i, :color => COLORS[i]} }
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

  def calculate_user_amount(user)
    @budget.categories.inject(0) do |sum,category|
        sum += category.transactions.this_month.where(:user => user).sum(:amount)
    end
  end
end
