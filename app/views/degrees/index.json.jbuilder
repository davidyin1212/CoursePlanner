json.array!(@degrees) do |degree|
  json.extract! degree, :id, :degree_name, :degree_type, :degree_requirements
  json.url degree_url(degree, format: :json)
end
