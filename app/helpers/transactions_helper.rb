module TransactionsHelper
  def criteria_to_text criteria
		case criteria
		when 'user', 'category', 'date'
			t("transactions.index.transactions_by_criteria", :criteria => @filter_criteria)
		when 'custom'
			t("transactions.index.custom_filter")
		else
			t("transactions.index.all_transactions")
		end
  end

  def category_filter_link(category)
    categories = params[:categories].instance_of?(Array) ? params[:categories] : []
    selected= categories.include?(category.id.to_s)
    parameter = params.except(:categories)

    link = selected ? parameter.merge(:categories => categories - [category.id.to_s]) : parameter.merge(:categories => categories + [category.id])

    content = category_box(category,category.name)
    content += content_tag(:i,"", :class => "glyphicon glyphicon-ok pull-right") if selected

    link_to content.html_safe, link, :class => "list-group-item"
  end
end
