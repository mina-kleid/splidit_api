class Conversation < ActiveRecord::Base

  belongs_to :first_user,:foreign_key => "user1_id",:class_name => "User"
  belongs_to :second_user,:foreign_key => "user2_id",:class_name => "User"
  has_many :posts, foreign_key: "conversation_id", class_name: "ConversationPost"

  validates_presence_of :first_user,:second_user
  validates_uniqueness_of :user1_id, :scope => [:user2_id],:message => "Conversation already exists"

  def users
    User.where(:id => [user1_id,user2_id])
  end

  def other_user(user)
    (self.users - [user]).first
  end

  def reverse_pagination(page)
    pages = (self.posts.count.to_f / ConversationPost.per_page.to_f).ceil
    return -1 if page > pages
    return pages if pages <= 1
    reversed_page = pages - page + 1
    return reversed_page
  end

  def transactions(user)
    first_user_account_id = user.account.id
    second_user_account_id = self.other_user(user).account.id
    Transaction.where("(source_id = ?) and (target_id = ?)", first_user_account_id, second_user_account_id)
  end

end
