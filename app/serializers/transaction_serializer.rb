class TransactionSerializer < ActiveModel::Serializer

  attributes :id, :amount, :text, :transaction_type, :source, :target, :target_type, :date

  def source
    object.source.owner_id
  end

  def target
    object.target.owner_id
  end

  def date
    object.created_at
  end

  def target_type
    return "user" if object.target.owner.is_a?(User)
    return "group" if object.target.owner.is_a?(Group)
    return "bank" if object.target.owner.is_a?(BankAccount)
  end

end