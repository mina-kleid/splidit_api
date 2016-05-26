class AccountSerializer < ActiveModel::Serializer
  attributes :id, :iban, :bic, :account_name, :account_number, :blz
end