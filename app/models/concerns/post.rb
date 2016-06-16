module Post

  extend ActiveSupport::Concern

  included do
    belongs_to :user

    enum post_type: [:text,:transactions,:request,:request_accepted,:request_rejected]

    validates_presence_of :user,:text

    default_scope {order('created_at DESC')}
    self.per_page = 15
  end

  def self.create_post(user, target, text, post_type, amount = 0)
    if target.is_a?(Conversation)
      ConversationPost.new(:user => user, :conversation => target, text: text, amount: amount, post_type: post_type)
    elsif target.is_a?(Group)
      GroupPost.new(:user => user, :group => target, text: text, amount: amount, post_type: post_type)
    end
  end

end
