json.array!(@categories) do |category|
  json.extract! category, :name, :budget
  json.url category_url(category, format: :json)
end
