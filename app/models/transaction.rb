class Transaction < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :source, polymorphic: true

  enum transaction_type: [:debit, :credit]

  after_create :after_create_callback


  private


  def after_create_callback
    transaction_type = self.credit? ? Transaction.transaction_types[:debit] : Transaction.transaction_types[:credit]
    Transaction.create(:target => self.source, :source => self.target, :amount => self.amount,
                       :transaction_type => transaction_type)
  end

end
