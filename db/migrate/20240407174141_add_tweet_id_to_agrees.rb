class AddTweetIdToAgrees < ActiveRecord::Migration[7.1]
  def change
    add_column :agrees, :tweet_id, :integer
  end
end
