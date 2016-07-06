class Account < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  validates :balance, :numericality => { :greater_than_or_equal_to => 0 }
  has_many :transactions, foreign_key: "source_id", class_name: "Transaction"

end
