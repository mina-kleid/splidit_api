class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :text, :transaction_type, :source, :target

  def source
    object.source.owner_id
  end

  def target
    object.target.owner_id
  end

end