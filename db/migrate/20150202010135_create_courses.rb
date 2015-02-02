class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_code
      t.string :course_name
      t.text :course_description

      t.timestamps null: false
    end
  end
end
