module Post

  extend ActiveSupport::Concern

  included do
    belongs_to :user

    enum post_type: [:text,:transactions,:request,:request_accepted,:request_rejected]

    validates_presence_of :user
    validates_presence_of :text, unless: :amount?
    validates_presence_of :amount, unless: :text?

    default_scope {order('created_at ASC')}
    self.per_page = 15

  end

end
