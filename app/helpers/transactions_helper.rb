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
end
