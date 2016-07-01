class ChangePostTable < ActiveRecord::Migration
  def change
    rename_table :posts, :convesration_posts
  end
end
