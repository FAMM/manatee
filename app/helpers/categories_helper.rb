module CategoriesHelper
  def category_box(category,text="")
    content_tag(:span) do
      box = content_tag(:span,"&nbsp;".html_safe,
                   :class => "badge category_box has-tooltip",
                   :style => "background-color:#{category.color}",
                   :title => category.name,
                   :data => {:toggle => "tooltip", :placement => "top"}
      )
      (box + text).html_safe
    end
  end
end
