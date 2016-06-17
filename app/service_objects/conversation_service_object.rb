class ConversationServiceObject

  def self.create_request(source, target, conversation, amount, text)
    post = ConversationPost.new(:user => source, :conversation => conversation, amount: amount, :post_type => ConversationPost.post_types[:request])
    request = nil
    begin
      ActiveRecord::Base.transaction(requires_new: true) do
        request = RequestServiceObject.create(source.account, target.account, amount, text)
        post.save!
      end
    rescue Errors::RequestNotCompletedError => e
      raise e
    rescue StandardError => e
      puts e.inspect
      raise Errors::RequestNotCompletedError
    end
    APNS.send_notification(target.device_token, :alert => 'You have received a new post', :badge => 1, :sound => 'default',
                           :other => {:conversation_id => conversation.id}) unless target.device_token.nil?
    return [post, request]
  end

  def self.accept_request(request, conversation)

  end

  def self.reject_request(request, conversation)

  end

end