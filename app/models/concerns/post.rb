module Post
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    enum post_type: [:text,:transactions,:request,:request_accepted,:request_rejected]

    validates_presence_of :user,:text

    default_scope {order('created_at DESC')}
    self.per_page = 15
  end

end
