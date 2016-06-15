class ConversationPost < ActiveRecord::Base

  include Post

  self.table_name = "conversation_posts"

  belongs_to :conversation

  validates_presence_of :conversation

end



