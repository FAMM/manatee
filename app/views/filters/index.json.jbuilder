json.array!(@filters) do |filter|
  json.extract! filter, :name, :start_date, :end_date, :user_id, :conditions
  json.url filter_url(filter, format: :json)
end
