desc "This task is called by the Heroku scheduler add-on"
task :update_courses => :environment do
  run_python_scraper = `python scripts/scraper.py`
  course_json_file = File.read('scripts/all_courses.json')
  data_hash = JSON.parse(course_json_file)
  data_hash.default = ''

  data_hash.each do |course_code, sub_hash|
    res = Courses.find_by course_code: course_code
    if res.empty?
      Course.create({course_code: sub_hash['course_code'], course_name: sub_hash['course_name'], course_description: sub_hash['course_description'], created_at: 0, updated_at: 0, Lec: sub_hash['LEC'], Pra: sub_hash['PRA'], Fallsections: sub_hash['fallsections'], Tut: sub_hash['TUT'], Code: course_code, Wintersections: sub_hash['wintersections'], Sc: sub_hash['SC'], Cr: sub_hash['CR'], Sem: sub_hash['SEM']})
    else
      res.update({course_code: sub_hash['course_code'], course_name: sub_hash['course_name'], course_description: sub_hash['course_description'], created_at: 0, updated_at: 0, Lec: sub_hash['LEC'], Pra: sub_hash['PRA'], Fallsections: sub_hash['fallsections'], Tut: sub_hash['TUT'], Code: course_code, Wintersections: sub_hash['wintersections'], Sc: sub_hash['SC'], Cr: sub_hash['CR'], Sem: sub_hash['SEM']})    
    end
  end
end
