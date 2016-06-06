class RequestServiceObject

  def self.create(source, target, amount, post_target,text)
    request = Request.new(:source => source, :target => target, :amount => amount, :status => Request.statuses[:pending], text: text)
    post = Post.new(:user => source, :target => post_target, amount: amount, :post_type => Post.post_types[:request])
    Request.transaction do
      request.save
      post.save
    end
    return [post,request]
  end

  def self.accept(request, post_target)
    if request.pending?
      success , error_message = TransactionServiceObject.create(request.source, request.target, request.amount, request.text)
      if success
        post = Post.new(:user => request.target, :target => post_target, amount: request.amount, :post_type => Post.post_types[:request_accepted])
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
    return [false,"Request is not in Pending state"]
  end

  def self.reject(request, post_target)
    if request.pending?
      request.status = Request.statuses[:rejected]
      request.status_changed_at = DateTime.now
      post = Post.new(:user => request.target, :target => post_target, amount: request.amount, :post_type => Post.post_types[:request_rejected])
      Request.transaction do
        request.save
        post.save
      end
      return [true,post]
    end
    return [false,"Request is not in pending state"]
  end

end