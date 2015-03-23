class CourseUser < ActiveRecord::Base

  belongs_to :course
  belongs_to :user
  self.primary_key = :course_id

  serialize :section_ids, Array
end
