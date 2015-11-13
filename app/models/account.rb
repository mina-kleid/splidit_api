class Account < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :iban,:bic,:account_name,:user
  validates_uniqueness_of :iban

  after_validation :validate_iban


  private


  def validate_iban
    unless IBANTools::IBAN.valid?(self[:iban])
      self.errors.add :iban, self.errors.generate_message(:iban, :invalid)
      return false
    end
    return true
  end

end
