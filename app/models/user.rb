# require_dependency 'validators/email_validator.rb'
class User < ActiveRecord::Base

  attr_accessor :password

  before_create :generate_authentication_token,:encrypt_password

  has_many :accounts
  has_many :transactions,:as => :source

  validates_presence_of :name,:email,:phone,:password
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
    puts password.inspect
    encrypted_password = BCrypt::Engine.hash_secret(password,self.salt)
    puts encrypted_password
    puts self.encrypted_password
    encrypted_password == self.encrypted_password
  end

  private

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
