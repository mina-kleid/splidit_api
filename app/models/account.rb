class Account < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  validates :balance, :numericality => { :greater_than_or_equal_to => 0 }
end
