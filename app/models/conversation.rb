class Conversation < ActiveRecord::Base

  belongs_to :first_user,:foreign_key => "user1_id",:class => "User"
  belongs_to :second_user,:foreign_key => "user2_id",:class => "User"

end
