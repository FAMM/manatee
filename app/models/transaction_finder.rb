class TransactionFinder
  attr_reader :sorting

  SORTING_OPTIONS=[:date,:category,:user]

  def initialize(budged,categories,sorting=nil)
    @budged = budged
    @scope = budged.transactions.where(nil)

    set_sorting_parameter(sorting.try(:to_sym))
    @categories = categories.instance_of?(Array) ? categories : []

    self.sort; self.filter
  end

  def transactions
    @scope
  end


  def sort
    case @sorting
      when :category then
        @scope = @scope.includes(:category).order("categories.name asc, date desc")
      when :user then
        @scope = @scope.includes(:user).order("users.name asc, date desc")
      else
        @scope = @scope.order("date desc")
    end
  end

  def filter
    @scope = @scope.where(:category_id => @categories) if @categories.any?
  end

  private
  def set_sorting_parameter(sorting)
    @sorting = SORTING_OPTIONS.include?(sorting) ? sorting : :date
  end
end