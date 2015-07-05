class User < ActiveRecord::Base

  attr_accessor :name,:email,:phone
  attr_reader :secret,:key,:balance,:sent_transactions,:received_transactions

  before_create :set_key_and_secret

  has_many :accounts

  #TODO for some reason not possible to specify source type and item for has_many without through

  def sent_transactions
    Transaction.where(:sender_id => self.id,:sender_type => "User")
  end

  def received_transactions
    Transaction.where(:receiver_id => self.id,:receiver_type => "User")
  end

  def sent_requests
    Request.where(:sender_id => self.id,:sender_type => "User")
  end

  def received_requests
    Request.where(:receiver_id => self.id,:receiver_type => "User")
  end


  private

  def set_key_and_secret
    self[:secret] = OAuth::Helper.generate_key(40)[0,40]
    self[:key] = OAuth::Helper.generate_key(40)[0,40]
  end

end
