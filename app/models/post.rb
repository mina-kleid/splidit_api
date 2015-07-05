class Post < ActiveRecord::Base
  belongs_to :author, polymorphic: true

  attr_accessor :type,:content

end
