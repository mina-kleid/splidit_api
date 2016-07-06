class User < ActiveRecord::Base

  attr_accessor :password

  before_create :generate_authentication_token
  before_validation :modify_phone_number
  after_create :create_account

  has_many :bank_accounts
  has_one :account, as: :owner

  has_many :source_requests, :as => :source,:class_name => "Request"
  has_many :target_requests, :as => :target,:class_name => "Request"

  validates_presence_of :name,:email,:phone,:password
  validates :phone, phone: { possible: true, types: [:mobile], allow_blank: true  }
  validates_uniqueness_of :email,:phone
  validates :email, email: true
  validates_length_of :password, minimum: 6
  validates_length_of :pin, is: 4, allow_nil: true

  def conversations
    Conversation.where("user1_id = ? or user2_id = ?",self.id,self.id)
  end

  def sent_requests
    Request.where(source: self.account)
  end

  def received_requests
    Request.where(target: self.account)
  end

  def transactions
    self.account.transactions
  end

  def authenticate(password)
    encrypted_password = BCrypt::Engine.hash_secret(password,self.salt)
    encrypted_password == self.encrypted_password
  end

  def authenticate_pin(pin)
    encrypted_pin = BCrypt::Engine.hash_secret(pin,self.salt)
    encrypted_pin == self.encrypted_pin
  end

  def pin
    @pin ||= encrypted_pin
  end

  def pin=(new_pin)
    @pin = new_pin
    self.encrypted_pin = BCrypt::Engine.hash_secret(new_pin, salt)
  end

  def password
    @password ||= self.encrypted_password
  end

  def password=(new_password)
    salt ||= generate_salt
    @password = new_password
    self.encrypted_password = BCrypt::Engine.hash_secret(new_password,salt)
  end

  def balance
    self.account.balance
  end

  private

  def create_account
    account = Account.new
    account.owner = self
    account.save
  end

  def modify_phone_number
    phone_number = Phonelib.parse(self.phone).international
    self[:phone] = phone_number if phone_number.present?
  end

  def generate_authentication_token
    loop do
      self[:authentication_token] = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end
  end

  def generate_salt
    salt = BCrypt::Engine.generate_salt
    self[:salt] = salt
  end

end
