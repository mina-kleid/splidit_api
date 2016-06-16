class Request < ActiveRecord::Base

  belongs_to :target, class_name: "Account"
  belongs_to :source, class_name: "Account"

  enum status: [:accepted,:pending,:rejected]

end
