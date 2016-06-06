class RequestSerializer < ActiveModel::Serializer
  attributes :id,:status,:amount, :text
end
