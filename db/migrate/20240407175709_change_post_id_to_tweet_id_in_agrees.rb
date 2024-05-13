class ChangePostIdToTweetIdInAgrees < ActiveRecord::Migration[7.1]
  def change
    remove_column :agrees, :post_id
  end
end
