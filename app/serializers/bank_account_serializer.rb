class BankAccountSerializer < ActiveModel::Serializer
  root :account
  attributes :id, :iban, :bic, :name, :account_holder, :account_number, :blz
end