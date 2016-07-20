class PushNotificationServiceObject

  def self.sendNotification(user, conversation, text )
    APNS.send_notification(user.device_token, :alert => text, :badge => 1, :sound => 'default',
                           :other => {:conversation_id => conversation.id, balance: user.account.balance}) unless user.device_token.nil?
  end

end