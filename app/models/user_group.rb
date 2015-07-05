class UserGroup < ActiveRecord::Base

  attr_accessor :is_admin

  belongs_to :user
  belongs_to :group

end
