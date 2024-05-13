class AddTeacherIdToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :teacher_id, :integer
  end
end
