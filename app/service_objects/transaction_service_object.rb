class TransactionServiceObject

  def self.create(source, target, amount, text)
    raise Errors::TransactionAmountMustBePositive.new("Amount must be higher than zero") and return if amount <= 0
    source_account = source.account
    target_account = target.account
    raise Errors::InsufficientFundsError.new("Insufficient funds") and return if source_account.balance - amount < 0
    debit_transaction = Transaction.new(:source => source_account,:target => target_account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit], balance_before: source_account.balance, balance_after: source_account.balance - amount, text: text)
    credit_transaction = Transaction.new(:source => target_account,:target => source_account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit], balance_before: target_account.balance, balance_after: target_account.balance + amount, text: text)
    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        debit_transaction.save!
        credit_transaction.save!
        source_account.update_attributes!(balance: source_account.balance - amount)
        target_account.update_attributes!(balance: target_account.balance + amount)
      end
    rescue StandardError => e
      raise Errors::TransactionNotCompletedError.new(e.message)
    end
    return debit_transaction
  end
end