class TransactionServiceObject

  def self.create(source, target, amount, text)
    source_account = source.account
    target_account = target.account
    if source_account.balance - amount > 0
      debit_transaction = Transaction.new(:source => source_account,:target => target_account,:amount => amount,:transaction_type => Transaction.transaction_types[:debit], balance_before: source_account.balance, balance_after: source_account.balance - amount, text: text)
      credit_transaction = Transaction.new(:source => target_account,:target => source_account,:amount => amount,:transaction_type => Transaction.transaction_types[:credit], balance_before: target_account.balance, balance_after: target_account.balance + amount, text: text)
      Transaction.transaction do
        debit_transaction.save
        credit_transaction.save
        source_account.update_attributes!(balance: source_account.balance - amount)
        target_account.update_attributes!(balance: target_account.balance + amount)
      end
      return true
    end
    return false
  end

end