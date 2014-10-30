json.array!(@jobs) do |job|
  json.extract! job, :id, :title, :description, :location, :remote, :industry, :type
  json.url job_url(job, format: :json)
end
