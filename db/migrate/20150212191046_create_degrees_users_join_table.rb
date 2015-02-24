class CreateDegreesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :degrees_users, id: false do |t|
      t.integer :degree_id
      t.integer :user_id
    end
    
    add_index :degrees_users, :degree_id
    add_index :degrees_users, :user_id
  end
end
