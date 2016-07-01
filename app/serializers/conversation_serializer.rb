class ConversationSerializer < ActiveModel::Serializer
  attributes :id,:user1_id,:user2_id

  has_many :posts

  def posts
      object.posts.limit(1)
  end

  def user1_id
    return object.user1_id if serialization_options[:current_user_id].equal?(object.user1_id)
    return object.user2_id
  end

  def user2_id
    return object.user2_id unless serialization_options[:current_user_id].equal?(object.user2_id)
    return object.user1_id
  end

end
