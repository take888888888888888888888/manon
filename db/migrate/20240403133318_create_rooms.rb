class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :roomname
      t.string :teacher
      t.integer :year
      t.string :semester
      t.string :day_of_week
      t.string :period

      t.timestamps
    end
  end
end
