class RemoveCreatorIdFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :creator_id
  end
end
