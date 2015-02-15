#Scheduler for courses
require 'json'

#Input: list of courses
#	Format: [[course_code],[]]


#Algorithm:

class Scheduler
	def initialize()
	
	end
	
	def calculate_overlap()
	
	end
end

data_hash = JSON.parse(course_json_file)

data_hash.each do |course_code, sub_hash|
	#Unpack array
	#Iterate through all keys in array, except section
#	sub_hash.each do |key, value|
#			
#	end
	#Unpack sections
	
	puts key
	puts array
	#If not in table, create new entry
	
	#Else update entry
	
end