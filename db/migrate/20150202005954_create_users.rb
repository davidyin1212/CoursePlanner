class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest 		#for storing crypted passwords

      t.timestamps null: false
    end

    create_table :courses_user do |t|
    	t.integer :course_id
    	t.integer :user_id
    end

    create_table :degrees_user do |t|
    	t.integer :degree_id
    	t.integer :user_id
    end

    add_index(:courses_user, [:course_id, :user_id])
    add_index(:degrees_user, [:degree_id, :user_id])
  end
end
