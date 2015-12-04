class TransactionServiceObject

  def self.create(source,target,amount,post_target=nil)
    if source.balance - amount > 0
      debit_transaction = Transaction.new(:source => source,:target => target,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
      credit_transaction = Transaction.new(:source => target,:target => source,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
      post = Post.new(:user => source,:target => post_target,:text => "#{source.name} sent #{amount} to #{target.name}",:post_type => Post.post_types[:text]) if post_target.present?
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