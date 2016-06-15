class GroupPost < ActiveRecord::Base

  include Post

  belongs_to :group
end


