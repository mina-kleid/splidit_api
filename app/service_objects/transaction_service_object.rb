class TransactionServiceObject

  def self.create(source,target,amount,post_target=nil,text)
    if source.balance - amount > 0
      debit_transaction = Transaction.new(:source => source,:target => target,:amount => amount,:transaction_type => Transaction.transaction_types[:debit], balance_before: source.balance, balance_after: source.balance - amount, text: text)
      credit_transaction = Transaction.new(:source => target,:target => source,:amount => amount,:transaction_type => Transaction.transaction_types[:credit], balance_before: target.balance, balance_after: target.balance + amount, text: text)
      post = Post.new(:user => source,:target => post_target,:amount => amount,:post_type => Post.post_types[:transactions]) if post_target.present?
      Transaction.transaction do
        debit_transaction.save
        credit_transaction.save
        source.update_attribute(:balance ,source.balance - amount)
        target.update_attribute(:balance , target.balance + amount)
        post.save if post_target.present?
      end
      return [true,post] if post_target.present?
      return [true,nil]
    end
    return [false,"Insufficient Funds"]
  end

end