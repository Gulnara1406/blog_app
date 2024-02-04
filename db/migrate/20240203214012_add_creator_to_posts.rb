class AddCreatorToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference(:posts, :creator, null: true, foreign_key: true)
  end
end
