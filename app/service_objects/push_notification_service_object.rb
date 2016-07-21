class PushNotificationServiceObject

  def self.sendNotification(user, conversation, post )
    alert_text = alert_text(post)
    APNS.send_notification(user.device_token, :alert => alert_text, :badge => 1, :sound => 'default',
                           :other => {conversation_id: conversation.id, balance: user.account.balance, post: PostSerializer.new(post, root: false)}) unless user.device_token.nil?
  end


  private


  def self.alert_text(post)
    case post.post_type
      when ConversationPost.post_types[:text]
        return post.text
      when ConversationPost.post_types[:transactions]
        return "You have received money"
      when ConversationPost.post_types[:request]
        return "You have a new money request"
      when ConversationPost.post_types[:request_accepted]
        return "Your money request have been accepted"
      when ConversationPost.post_types[:request_rejected]
        return "Your money request have been rejected"
    end
  end

end