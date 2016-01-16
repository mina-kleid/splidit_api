class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true

  enum post_type: [:text,:transactions,:request,:request_accepted,:request_rejected]

  validates_presence_of :user,:target,:text
end
