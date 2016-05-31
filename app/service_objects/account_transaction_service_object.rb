class AccountTransactionServiceObject

  def self.withdraw_from_account(account,user,amount)
    debit_transaction = Transaction.new(:source => account,:target => user,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
    credit_transaction = Transaction.new(:source => user,:target => account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit], balance: user.balance + amount)
    Transaction.transaction do
      debit_transaction.save
      credit_transaction.save
      user.update_attribute(:balance,user.balance + amount)
    end
    return true
  end

  def self.deposit_to_account(account,user,amount)
    debit_transaction = Transaction.new(:source => user,:target => account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit], balance: user.balance - amount)
    credit_transaction = Transaction.new(:source => account,:target => user,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
    if user.balance - amount > 0
      Transaction.transaction do
        debit_transaction.save
        credit_transaction.save
        user.update_attribute(:balance,user.balance - amount)
      end
      return true
    end
    return false
  end


end