class ConversationServiceObject

  def self.create_request(source, target, conversation, amount, text)
    post = ConversationPost.new(:user => source, :conversation => conversation, text: text, amount: amount, :post_type => ConversationPost.post_types[:request])
    request = nil
    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        request = RequestServiceObject.create(source.account, target.account, amount, text)
        post.save!
      end
    rescue Errors::RequestNotCompletedError => e
      raise e
    rescue StandardError => e
      raise Errors::RequestNotCompletedError
    end
    APNS.send_notification(target.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                           :other => {:conversation_id => conversation.id}) unless target.device_token.nil?
    return [post, request]
  end

  def self.accept_request(request, conversation)
    post = ConversationPost.new(:user => request.target.owner, :conversation => conversation, amount: request.amount, :post_type => ConversationPost.post_types[:request_accepted])
    transaction = nil
    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        transaction = RequestServiceObject.accept(request)
        post.save!
      end
    rescue StandardError => e
      raise e
    end
    APNS.send_notification(request.source.owner.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                           :other => {:conversation_id => conversation.id}) unless request.source.owner.device_token.nil?
    return [post, transaction]
  end

  def self.reject_request(request, conversation)
    post = ConversationPost.new(:user => request.target.owner, :conversation => conversation, amount: request.amount, :post_type => ConversationPost.post_types[:request_rejected])
    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        RequestServiceObject.reject(request)
        post.save!
      end
    rescue StandardError => e
      raise e
    end
    APNS.send_notification(request.source.owner.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                           :other => {:conversation_id => conversation.id}) unless request.source.owner.device_token.nil?
    return post
  end

  def self.create_transaction(source, target, conversation, amount, text)
    post = ConversationPost.new(:user => source, :conversation => conversation, text: text, amount: amount, :post_type => ConversationPost.post_types[:transactions])
    transaction = nil
    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        transaction = TransactionServiceObject.create(source, target, amount, text)
        post.save!
      end
    rescue StandardError => e
      raise e
    end
    APNS.send_notification(target.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                           :other => {:conversation_id => conversation.id}) unless target.device_token.nil?
    return [post, transaction]
  end

end