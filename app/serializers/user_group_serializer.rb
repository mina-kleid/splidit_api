class UserGroupSerializer < ActiveModel::Serializer

  attributes :is_admin

  has_one :user, :serializer => UserForGroupSerializer

end
