json.array!(@transactions) do |transaction|
  json.extract! transaction, :amount, :comment
  json.url transaction_url(transaction, format: :json)
end
