class RequestServiceObject

  def self.create(source, target, amount, post_target)
    request = Request.new(:source => source, :target => target, :amount => amount, :status => Request.statuses[:pending])
    post = Post.new(:user => source, :target => post_target, :text => "#{source.name} requests #{amount} from #{target.name}", :post_type => Post.post_types[:text])
    Request.transaction do
      request.save
      post.save
    end
    return post
  end

  def self.accept(request, post_target)
    if request.pending?
      success , error_message = TransactionServiceObject.create(request.source, request.target, request.amount)
      if success
        post = Post.new(:user => request.target, :target => post_target, :text => "#{request.target.name} has accepted the request of #{request.amount} from #{request.source.name}", :post_type => Post.post_types[:text])
        request.status = Request.statuses[:accepted]
        request.status_changed_at = DateTime.now
        Request.transaction do
          request.save
          post.save
        end
        return [true,post]
      end
      return [false,error_message]
    end
    return [false,"Request is not in Pending stateß"]
  end

  def self.reject(request, post_target)
    if request.pending?
      request.status = Request.statuses[:rejected]
      request.status_changed_at = DateTime.now
      post = Post.new(:user => request.target, :target => post_target, :text => "#{request.target.name} has rejected the request of #{request.amount} from #{request.source.name}", :post_type => Post.post_types[:text])
      Request.transaction do
        request.save
        post.save
      end
      return [true,post]
    end
    return [false,"Request is not in pending state"]
  end

end