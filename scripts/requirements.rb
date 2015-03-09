#Requirement class for degrees

class Requirement
	def initialize(course_list=[], num_courses=0)
		#Initialize with a list of required courses and the number of courses needed to fulfil this req
		@course_list = course_list
		@courses_added = [];
		@num_courses = num_courses
		@fulfilled = false
	end

	def initialize_from_string(req_string)
		# #Initialize with a list of required courses and the number of courses needed to fulfil this req
		req_array = eval(req_string)
		@course_list = req_array[1..-1]
		@courses_added = []
		@num_courses = req_array[0]
		@fulfilled = false
	end
	
	def add_courses_taken(courses_to_add)
		#Add a course taken
		@courses_added += courses_to_add
		#Update req and check if fulfilled
		check_if_fulfilled()
	end

	def add_courses_required(courses_to_add)
		#Add a course requirement
		@course_list += courses_to_add
		#Update req and check if fulfilled
		check_if_fulfilled()
	end
	
	def delete_courses_taken(courses_to_delete)
		#Remove a course taken
		@courses_added -= courses_to_delete
		#Update req and check if fulfilled
		check_if_fulfilled()		
	end

	def delete_courses_required(courses_to_delete)
		#Remove a course requirement
		@course_list -= courses_to_delete
		#Update req and check if fulfilled
		check_if_fulfilled()		
	end
	
	def update_num_courses(new_num_courses)
		#Change number of courses needed to fulfil this req
		@num_courses = new_num_courses
		check_if_fulfilled()
	end
	
	def check_if_fulfilled()
		#Check if enough courses in course_list have been taken (are in courses_added)
		num_courses_fulfilled = 0
		@course_list.each do |course_code|
			if @courses_added.include?(course_code)
				num_courses_fulfilled += 1
			end
		end
		@fulfilled = num_courses_fulfilled >= @num_courses
	end
	
	def is_fulfilled?()
		return @fulfilled
	end

	def output_requirements()
		return ([@num_courses] + @course_list).to_s
	end
end