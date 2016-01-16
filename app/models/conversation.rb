class Conversation < ActiveRecord::Base

  belongs_to :first_user,:foreign_key => "user1_id",:class_name => "User"
  belongs_to :second_user,:foreign_key => "user2_id",:class_name => "User"
  has_many :posts,:as => :target

  validates_presence_of :first_user,:second_user
  validates_uniqueness_of :user1_id, :scope => [:user2_id],:message => "Conversation already exists"

  def users
    User.where(:id => [user1_id,user2_id])
  end

  def other_user(user)
    (self.users - [user]).first
  end

end
