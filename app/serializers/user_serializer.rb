class UserSerializer < ActiveModel::Serializer

  attributes :id,:name,:email,:phone,:token

  def token
    @object.authentication_token
  end

end