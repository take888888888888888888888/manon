class CreateRoomTags < ActiveRecord::Migration[7.1]
  def change
    create_table :room_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
