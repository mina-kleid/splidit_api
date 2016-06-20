class RequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :amount, :text, :source, :target

  def source
    object.source.owner
  end

  def target
    object.target.owner
  end

end
