class ChangePostTable < ActiveRecord::Migration
  def change
    rename_table :posts, :conversation_posts
  end
end
