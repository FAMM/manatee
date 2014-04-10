class BudgetStatistics
  attr_accessor :budget

  def initialize(budget)
    @budget=budget
  end

  def category_distribution
    @budget.categories.map {|category| {:value => category.used_this_month.to_i, :color => category.color} }
  end

end