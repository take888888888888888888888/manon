class CreateUserCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_courses do |t|
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
  end
end
