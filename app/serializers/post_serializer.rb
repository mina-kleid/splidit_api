class PostSerializer < ActiveModel::Serializer
  attributes :id, :text, :post_type, :source_id, :amount

  def source_id
    object.user_id
  end

end
