module TransactionsHelper
  def criteria_to_text criteria
		case criteria
		when 'all'
			t("transactions.index.all_transactions")
		when 'user', 'category', 'date'
			t("transactions.index.transactions_by_criteria", :criteria => @filter_criteria)
		else
			t("transactions.index.custom_filter")
		end
	end
end
