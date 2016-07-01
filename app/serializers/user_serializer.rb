class UserSerializer < ActiveModel::Serializer

  attributes :id,:name,:email,:phone,:token,:balance

  def token
    @object.authentication_token
  end

  def balance
    @object.account.balance
  end

end