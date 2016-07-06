class BankAccountTransactionServiceObject

  def self.withdraw_from_bank_account(bank_account,user,amount)
    raise Errors::TransactionAmountMustBePositive.new("Amount must be higher than zero") and return if amount <= 0
    user_account = user.account
    debit_transaction = Transaction.new(:source => bank_account.account,:target => user_account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
    credit_transaction = Transaction.new(:source => user_account,:target => bank_account.account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit], balance_after: user_account.balance + amount, balance_before: user_account.balance)
    begin
      Transaction.transaction do
        debit_transaction.save!
        credit_transaction.save!
        user_account.update_attributes!(balance: user_account.balance + amount)
      end
    rescue StandardError => e
      raise Errors::TransactionNotCompletedError.new(e.message)
    end
  end

  def self.deposit_to_bank_account(bank_account,user,amount)
    raise Errors::TransactionAmountMustBePositive.new("Amount must be higher than zero") and return if amount <= 0
    user_account = user.account
    raise Errors::InsufficientFundsError.new("Insufficient funds") and return if user_account.balance - amount < 0
    debit_transaction = Transaction.new(:source => user_account,:target => bank_account.account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit], balance_after: user_account.balance - amount, balance_before: user_account.balance)
    credit_transaction = Transaction.new(:source => bank_account.account,:target => user_account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
    begin
      Transaction.transaction do
        debit_transaction.save!
        credit_transaction.save!
        user_account.update_attributes!(balance: user_account.balance - amount)
      end
    rescue StandardError => e
      raise Errors::TransactionNotCompletedError.new(e.message)
    end
  end


end