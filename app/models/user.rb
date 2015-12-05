# require_dependency 'validators/email_validator.rb'
class User < ActiveRecord::Base

  attr_accessor :password

  before_create :generate_authentication_token,:encrypt_password
  before_validation :modify_phone_number

  has_many :accounts
  has_many :transactions,:as => :source
  has_many :source_requests, :as => :source,:class_name => "Request"
  has_many :target_requests, :as => :target,:class_name => "Request"

  validates_presence_of :name,:email,:phone,:password
  validates :phone, phone: { possible: true, types: [:mobile] }
  validates_uniqueness_of :email,:phone
  validates :email, email: true
  validates_length_of :password, minimum: 6

  def conversations
    Conversation.where("user1_id = ? or user2_id = ?",self.id,self.id)
  end

  def sent_requests
    Request.where(:sender_id => self.id,:sender_type => "User")
  end

  def received_requests
    Request.where(:receiver_id => self.id,:receiver_type => "User")
  end

  def authenticate(password)
    encrypted_password = BCrypt::Engine.hash_secret(password,self.salt)
    encrypted_password == self.encrypted_password
  end

  private

  def modify_phone_number
    self[:phone] = Phonelib.parse(self.phone).international
  end

  def generate_authentication_token
    loop do
      self[:authentication_token] = SecureRandom.base64(64)
      break unless User.find_by(authentication_token: authentication_token)
    end
  end

  def encrypt_password
    salt = BCrypt::Engine.generate_salt
    self[:encrypted_password] = BCrypt::Engine.hash_secret(@password, salt)
    self[:salt] = salt
  end

end
