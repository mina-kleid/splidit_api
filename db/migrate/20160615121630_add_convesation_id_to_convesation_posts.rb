class AddConvesationIdToConvesationPosts < ActiveRecord::Migration
  def change
    remove_reference :conversation_posts, :target, polymorphic: true, index: true
    add_reference :conversation_posts, :conversation
  end
end
