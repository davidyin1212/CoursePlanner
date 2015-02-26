#Script to scrape for course info and add it to database
require 'json'
require 'pg'

# Run python script to generate json file
#run_python_scraper = `python scraper.py`

#Partial list for testing
course_json_file = File.read('master_timetable_partial.json')
#course_json_file = File.read('all_courses.json')

data_hash = JSON.parse(course_json_file)

#Connect to database
conn=PGconn.connect( :hostaddr=>"127.0.0.1", :port=>3000, :dbname=>"test", :user=>"postgres", :password=>'1234')


data_hash.each do |course_code, sub_hash|
	#Unpack array
	#Iterate through all keys in array, except section
#	sub_hash.each do |key, value|
#			
#	end
	#Unpack sections
#	INSERT INTO table_name (column1,column2,column3,...)
#VALUES (value1,value2,value3,...);

#UPDATE table_name
#SET column1=value1,column2=value2,...
#WHERE some_column=some_value;
	#Check if in table
	res = conn.exec('SELECT * FROM courses WHERE code = \'' + course_code + '\'')
	if res.ntuples == 0
	#If not in table, create new entry
		column_names = ''
		values = ''
		sub_hash.each do |field_name, field_value|
			column_names += field_name.to_s + ','
			values += '\'' + field_value.to_s.gsub('\'','\'\'') + '\','
		end
		column_names = column_names[0..-2]
		values = values[0..-2]
#		puts 'INSERT INTO courses (' + column_names + ') VALUES(' + values + ')'
		sql_command = 'INSERT INTO courses (' + column_names + ') VALUES(' + values + ')'
		conn.exec(sql_command)
	else
	#Else update entry
		column_value_pairs = ''
		sub_hash.each do |field_name, field_value|
			column_value_pairs += field_name.to_s + '=\'' + field_value.to_s.gsub('\'','\'\'') + '\','
		end
		column_names = column_names[0..-2]
		sql_command = 'UPDATE courses SET ' + column_value_pairs + 'WHERE code = \'' + course_code + '\''
		conn.exec(sql_command)	
	end

end