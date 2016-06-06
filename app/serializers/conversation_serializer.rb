class ConversationSerializer < ActiveModel::Serializer
  attributes :id,:user1_id,:user2_id

  has_many :posts

  def posts
    if serialization_options[:show_all_posts]
      object.posts
    elsif serialization_options[:show_paged_posts]
      object.posts.page(serialization_options[:page])
    else
      object.posts.limit(1)
    end
  end
end
