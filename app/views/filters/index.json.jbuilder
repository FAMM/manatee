json.array!(@filters) do |filter|
  json.extract! filter, :id, :name, :start_date, :end_date, :conditions
  json.url filter_url(filter, format: :json)
end
