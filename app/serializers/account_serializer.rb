class AccountSerializer < ActiveModel::Serializer
  attributes :id,:iban,:bic,:account_name
end