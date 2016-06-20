class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :text, :transaction_type, :source, :target

  def source
    object.source.owner
  end

  def target
    object.target.owner
  end

end