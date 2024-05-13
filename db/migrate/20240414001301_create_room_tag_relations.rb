class CreateRoomTagRelations < ActiveRecord::Migration[7.1]
  def change
    create_table :room_tag_relations do |t|
      t.references :room, null: false, foreign_key: true
      t.references :roomtag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
