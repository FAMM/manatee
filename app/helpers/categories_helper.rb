module CategoriesHelper
  def category_box(category,text="")
    box(category.color,category.name,text)
  end
end
