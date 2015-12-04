class AccountTransactionServiceObject

  def self.withdraw_from_account(account,user,amount)
    Transaction.transaction do
      Transaction.create(:source => account,:target => user,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
      Transaction.create(:source => user,:target => account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
      user.update_attribute(:balance => user.balance + amount)
    end
  end

  def self.deposit_to_account(account,user,amount)
    if user.balance - amount > 0
      Transaction.transaction do
        Transaction.create(:source => account,:target => user,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
        Transaction.create(:source => user,:target => account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
        user.update_attribute(:balance => user.balance - amount)
      end
    end
  end


end