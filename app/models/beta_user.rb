class BetaUser < ActiveRecord::Base

  validates_presence_of :first_name, :last_name, :email
  validates :email, email: true

end
