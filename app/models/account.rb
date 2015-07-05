class Account < ActiveRecord::Base
  belongs_to :user

  attr_accessor :iban,:bic,:account_name,:user

end
