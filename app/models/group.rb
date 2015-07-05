class Group < ActiveRecord::Base

  attr_accessor :name,:type,:description,:creator,:sum_per_person
  attr_reader :balance

  has_many :posts, :as => :target

  has_many :user_groups
  has_many :users,:through => :user_groups

  has_one :creator, :class_name => "User",:foreign_key => :creator_id


  enum type: [:sum_per_person, :open_pot]

  def sent_transactions
    Transaction.where(:sender_id => self.id,:sender_type => "Group")
  end


  def received_transactions
    Transaction.where(:receiver_id => self.id,:receiver_type => "Group")
  end

  def sent_requests
    Request.where(:sender_id => self.id,:sender_type => "Group")
  end

  def received_requests
    Request.where(:receiver_id => self.id,:receiver_type => "Group")
  end

  def creator=(creator)
    self.creator_id = creator.id
    self.users << creator
    self.set_creator_as_admin
  end

  def set_creator_as_admin
    self.user_groups.first[:is_admin] = true if self.user_groups.first[:user_id].eql?(self[:creator_id])
  end

  def set_admins(admin_ids)
    puts admin_ids.inspect
    self.user_groups.map { |ug| ug[:is_admin] = true if admin_ids.include?(ug.user_id)}
  end

end
