class CreateCoursesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :courses_users, id: false do |t|
      t.integer :course_id
      t.integer :user_id
    end
    
    add_index :courses_users, :course_id
    add_index :courses_users, :user_id
  end
end
