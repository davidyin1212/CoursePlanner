json.array!(@courses) do |course|
  json.extract! course, :id, :course_code, :course_name, :course_description
  json.url course_url(course, format: :json)
end
