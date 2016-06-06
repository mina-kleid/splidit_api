class Account < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :account_number, :blz, unless: (:iban? || :account_holder)
  validates_presence_of :account_holder, :iban, unless: (:account_number? || :blz?)

  before_validation :generate_iban, if: Proc.new {|account| account.account_number.present? && account.blz.present? && account.iban.blank?}
  before_validation :validate_iban, if: :iban?

  private

  def generate_iban
    ibanizator =  Ibanizator.new
    iban = ibanizator.calculate_iban country_code: :de, bank_code: blz, account_number: account_number
    if Ibanizator.iban_from_string(iban).valid?
      self.iban = iban and return
    else
      self.errors.add :account_number, self.errors.generate_message(:account_number, :invalid)
      self.errors.add :blz, self.errors.generate_message(:blz, :invalid)
    end
  end

  def validate_iban
    unless Ibanizator.iban_from_string(self[:iban]).valid?
      self.errors.add :iban, self.errors.generate_message(:iban, :invalid)
      return false
    end
    return true
  end

end
