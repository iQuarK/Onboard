json.array!(@companies) do |company|
  json.extract! company, :id, :name, :description, :industry, :location
  json.url company_url(company, format: :json)
end
