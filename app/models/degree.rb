class Degree < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_and_belongs_to_many :courses
	has_many :comments
	
	serialize :requirements, Array
end
