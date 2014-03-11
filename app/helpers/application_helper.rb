module ApplicationHelper
  def formated_currency *args
    currency = number_to_currency *args
    content_tag :span, currency, :class => "currency"
  end
end
