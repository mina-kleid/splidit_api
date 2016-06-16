class RequestServiceObject

  def self.create(source_account, target_account, amount,text)
    request = Request.new(:source => source_account, :target => target_account, :amount => amount, :status => Request.statuses[:pending], text: text)
    Request.transaction do
      request.save!
    end
    return request
  end

  def self.accept(request)
    Request.transaction do
      success = TransactionServiceObject.create(request.source.owner, request.target.owner, request.amount, request.text)
      if success
        request.status = Request.statuses[:accepted]
        request.status_changed_at = DateTime.now
        request.save!
      end
    end
    return true
  end

  def self.reject(request)
    if request.pending?
      request.status = Request.statuses[:rejected]
      request.status_changed_at = DateTime.now
      Request.transaction do
        request.save!
      end
      return true
    end
    return false
  end

end