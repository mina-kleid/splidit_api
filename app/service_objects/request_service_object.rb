class RequestServiceObject

  def self.create(source_account, target_account, amount,text)
    request = Request.new(:source => source_account, :target => target_account, :amount => amount, :status => Request.statuses[:pending], text: text)
    begin
      Request.transaction(requires_new: true) do
        request.save!
      end
    rescue StandardError => e
      raise RequestNotCompletedError
    end
    return request
  end

  def self.accept(request)
    begin
      Request.transaction(requires_new: true) do
        TransactionServiceObject.create(request.source.owner, request.target.owner, request.amount, request.text)
        request.status = Request.statuses[:accepted]
        request.status_changed_at = DateTime.now
        request.update_attributes!({status: Request.statuses[:accepted], status_changed_at: DateTime.now})
      end
    rescue Errors::InsufficientFundsError => e
      raise e
    rescue Errors::TransactionNotCompletedError => e
      raise e
    rescue StandardError => e
      raise Errors::RequestNotAcceptedError
    end
    return true
  end

  def self.reject(request)
      request.status = Request.statuses[:rejected]
      request.status_changed_at = DateTime.now
      begin
        Request.transaction(requires_new: true) do
          request.save!
        end
      rescue StandardError => e
        raise RequestNotRejectedError
      end
      return true
  end

end