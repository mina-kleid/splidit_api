class Account < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  validates :balance, :numericality => { :greater_than_or_equal_to => 0 }
  has_many :credit_transactions, foreign_key: "target_id", class_name: "Transaction"
  has_many :debit_transactions, foreign_key: "source_id", class_name: "Transaction"

  def transactions
    credit_transactions.union(debit_transactions).order("created_at ASC")
  end

end
