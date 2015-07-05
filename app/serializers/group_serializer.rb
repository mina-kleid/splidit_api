class GroupSerializer < ActiveModel::Serializer
  attributes :id,:name,:type,:description,:sum_per_person

  has_many :user_groups, :serializer => UserGroupSerializer, :key => :users


end
