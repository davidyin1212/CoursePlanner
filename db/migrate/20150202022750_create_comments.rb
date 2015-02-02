class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.integer :course_id
      t.integer :degree_id
      t.timestamps null: false
    end
  end
end
