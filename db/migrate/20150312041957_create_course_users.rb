class CreateCourseUsers < ActiveRecord::Migration
  def change
    create_table :course_users, id:false do |t|
        t.integer :course_id
        t.integer :user_id
        t.string  :lecture_id
        t.timestamps null: false
      end

      add_index :course_users, :course_id
      add_index :course_users, :user_id

    end
  end

