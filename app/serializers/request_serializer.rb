class RequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :amount, :text, :source, :target

  def source
    object.source.owner_id
  end

  def target
    object.target.owner_id
  end

end
