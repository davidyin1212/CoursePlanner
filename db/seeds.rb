# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

course_json_file = File.read('db/master_timetable_partial.json')
#course_json_file = File.read('all_courses.json')
#Course.create({course_name: 'abc'})
data_hash = JSON.parse(course_json_file)
data_hash.default = ''

data_hash.each do |course_code, sub_hash|
	res = Course.create({course_code: sub_hash['course_code'], course_name: sub_hash['course_name'], course_description: sub_hash['course_description'], created_at: 0, updated_at: 0, Lec: sub_hash['LEC'], Pra: sub_hash['PRA'], Fallsections: sub_hash['fallsections'], Tut: sub_hash['TUT'], Code: course_code, Wintersections: sub_hash['wintersections'], Sc: sub_hash['SC'], Cr: sub_hash['CR'], Sem: sub_hash['SEM']})
end
