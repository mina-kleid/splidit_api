class Conversation < ActiveRecord::Base

  belongs_to :first_user,:foreign_key => "user1_id",:class_name => "User"
  belongs_to :second_user,:foreign_key => "user2_id",:class_name => "User"

  validates_presence_of :first_user,:second_user

end
