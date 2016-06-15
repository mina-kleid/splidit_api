class Transaction < ActiveRecord::Base

  belongs_to :target, class_name: "Account"
  belongs_to :source, class_name: "Account"

  enum transaction_type: [:debit, :credit]

end
