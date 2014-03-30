module ApplicationHelper
  def formated_currency *args
    currency = number_to_currency *args
    content_tag :span, currency, :class => "currency"
  end

  def action_bar_link_to(text,path)
    class_string = "list-group-item"
    class_string += " active" if current_page?(path)

    link_to(text,path, :class => class_string)
  end

  def nav_tab_link_to(text,path)
    class_string = current_page?(path) ? "active":"inactive"
    content_tag :li, :class => class_string do
      link_to text, path
    end
  end
end
