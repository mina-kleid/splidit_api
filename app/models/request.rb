class Request < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true

  enum status: [:accepted,:pending,:rejected]

end
