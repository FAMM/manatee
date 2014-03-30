module CategoriesHelper
  def category_box(category,text="")
    content_tag(:div) do
      (content_tag(:span,"&nbsp;".html_safe, :class => "badge category_box", :style => "background-color:#{category.color}") + text).html_safe
    end
  end
end
