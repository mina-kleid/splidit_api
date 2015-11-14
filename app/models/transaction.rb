class Transaction < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :source, polymorphic: true

  enum transaction_type: [:debit, :credit]

end
