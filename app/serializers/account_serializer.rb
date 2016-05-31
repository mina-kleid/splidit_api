class AccountSerializer < ActiveModel::Serializer
  attributes :id, :iban, :bic, :name, :account_holder, :account_number, :blz
end