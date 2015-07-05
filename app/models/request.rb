class Request < ActiveRecord::Base
  belongs_to :sender, polymorphic: true
  belongs_to :receiver, polymorphic: true

  attr_accessor :sender,:receiver,:status,:amount

end
