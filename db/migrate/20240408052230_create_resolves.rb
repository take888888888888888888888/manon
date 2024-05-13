class CreateResolves < ActiveRecord::Migration[7.1]
  def change
    create_table :resolves do |t|
      t.integer :user_id
      t.integer :tweet_id

      t.timestamps
    end
  end
end
