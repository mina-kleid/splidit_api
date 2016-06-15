class ConversationSerializer < ActiveModel::Serializer
  attributes :id,:user1_id,:user2_id

  has_many :posts

  def posts
      object.posts.limit(1)
  end

end
