class TransactionServiceObject

  def self.create(source,target,amount)
    Transaction.transaction do
      Transaction.create(:source => source,:target => target,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
      Transaction.create(:source => target,:target => source,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
      if source.respond_to?(:balance)
        source.transaction {source.update_attribute(:balance ,source.balance - amount)}
      end
      if target.respond_to?(:balance)
        target.transaction {target.update_attribute(:balance , target.balance + amount)}
      end

    end
    return true
  end

end