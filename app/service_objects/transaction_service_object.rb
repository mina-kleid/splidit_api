class TransactionServiceObject

  def self.create(source,target,amount,post_target=nil)
    if source.balance - amount > 0
      Transaction.transaction do
        Transaction.create(:source => source,:target => target,:amount => amount,:transaction_type => Transaction.transaction_types[:debit])
        Transaction.create(:source => target,:target => source,:amount => amount,:transaction_type => Transaction.transaction_types[:credit])
        source.update_attribute(:balance ,source.balance - amount)
        target.update_attribute(:balance , target.balance + amount)
        return Post.create(:user => source,:target => post_target,:text => "#{source.name} sent #{amount} to #{target.name}",:post_type => Post.post_types[:text]) if post_target.present?
      end
    end
  end

end