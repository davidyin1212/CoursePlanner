#Script to scrape for course info and add it to database
require 'json'
require 'pg'

# Run python script to generate json file
#run_python_scraper = `python scraper.py`

#Partial list for testing
course_json_file = File.read('master_timetable_partial.json')
#course_json_file = File.read('master_timetable.json')

data_hash = JSON.parse(course_json_file)

#Connect to database
conn=PGconn.connect( :hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"megatest", :user=>"roger", :password=>'123456')


data_hash.each do |course_code, sub_hash|
	#Unpack array
	#Iterate through all keys in array, except section
#	sub_hash.each do |key, value|
#			
#	end
	#Unpack sections
	
	puts key
	puts array
	#Check if in table
	res = conn.exec("SELECT * FROM courses WHERE code = " + course_code)

	#If not in table, create new entry
	
	#Else update entry
	
end