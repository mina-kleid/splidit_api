class RequestServiceObject

  def self.create(source, target, amount,post_target)
    Request.transaction do
      Request.create(:source => source, :target => target, :amount => amount, :status => Request.statuses[:pending])
      post = Post.create(:user => source,:target => post_target,:text => "#{source.name} requests #{amount} from #{target.name}",:post_type => Post.post_types[:text])
      return post
    end
  end

  def self.accept(request,post_target)
    if request.pending?
      Request.transaction do
        TransactionServiceObject.create(request.source, request.target, request.amount)
        request.status = Request.statuses[:accepted]
        request.status_changed_at = DateTime.now
        request.save
        post = Post.create(:user => request.target,:target => post_target,:text => "#{request.target.name} has accepted the request of #{amount} from #{request.source.name}",:post_type => Post.post_types[:text])
        return post
      end
    end
  end

  def self.reject(request,post_target)
    if request.pending?
      Request.transaction do
        request.status = Request.statuses[:rejected]
        request.status_changed_at = DateTime.now
        request.save
        post = Post.create(:user => request.target,:target => post_target,:text => "#{request.target.name} has rejected the request of #{amount} from #{request.source.name}",:post_type => Post.post_types[:text])
        return post
      end
    end
  end

end