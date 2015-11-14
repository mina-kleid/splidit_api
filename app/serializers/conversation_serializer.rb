class ConversationSerializer < ActiveModel::Serializer
  attributes :id,:user1_id,:user2_id


  has_many :posts

  def posts
    if serialization_options[:show_all_posts]
      object.posts
    else
      [object.posts.first]
    end
  end
end
