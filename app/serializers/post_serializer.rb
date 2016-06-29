class PostSerializer < ActiveModel::Serializer

  root :post
  attributes :id, :text, :post_type, :user_id, :amount, :created_at

end
