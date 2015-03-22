class CourseUser < ActiveRecord::Base

  belongs_to :course
  belongs_to :user
  self.primary_key = :user_id
end
