class PostSerializer < ActiveModel::Serializer

  attributes :id, :text, :post_type, :user_id, :amount, :created_at

end
