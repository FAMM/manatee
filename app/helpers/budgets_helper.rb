module BudgetsHelper
  def used_in_percent(used,planned)
    used / planned.to_f * 100
  end
end
