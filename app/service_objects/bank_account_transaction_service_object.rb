class BankAccountTransactionServiceObject

  def self.withdraw_from_account(bank_account,user,amount)
    user_account = user.account
    debit_transaction = Transaction.new(:source => bank_account.account,:target => user_account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
    credit_transaction = Transaction.new(:source => user_account,:target => bank_account.account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit], balance_after: user_account.balance + amount, balance_before: user_account.balance)
    Transaction.transaction do
      debit_transaction.save
      credit_transaction.save
      user_account.update_attribute(:balance, user_account.balance + amount)
    end
    return true
  end

  def self.deposit_to_account(bank_account,user,amount)
    user_account = user.account
    debit_transaction = Transaction.new(:source => user_account,:target => bank_account.account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit], balance_after: user_account.balance - amount, balance_before: user_account.balance)
    credit_transaction = Transaction.new(:source => bank_account.account,:target => user_account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
    if user_account.balance - amount > 0
      Transaction.transaction do
        debit_transaction.save
        credit_transaction.save
        user_account.update_attribute(:balance, user_account.balance - amount)
      end
      return true
    end
    return false
  end


end