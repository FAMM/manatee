class TransactionSorter
  attr_accessor :sorting

  SORTING_OPTIONS=[:date,:category,:user]

  def initialize(sorting)
    set_sorting_parameter(sorting.try(:to_sym))
  end


  def sort(transactions)
    case @sorting
      when :category then
        transactions.includes(:category).order("categories.name asc, date desc")
      when :user then
        transactions.includes(:user).order("users.name asc, date desc")
      else
        transactions.order("date desc")
    end

  end

  private
  def set_sorting_parameter(sorting)
    @sorting = SORTING_OPTIONS.include?(sorting) ? sorting : :date
  end
end