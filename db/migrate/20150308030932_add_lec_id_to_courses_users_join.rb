class AddLecIdToCoursesUsersJoin < ActiveRecord::Migration
  def change
    add_column :courses_users, :Lec_id, :string
  end
end
