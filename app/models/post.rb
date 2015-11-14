class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true

  enum post_type: [:debit,:credit,:text]

  validates_presence_of :user,:target,:text
end
