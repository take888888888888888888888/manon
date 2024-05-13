class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.text :body
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
  end
end
