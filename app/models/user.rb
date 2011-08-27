class User < ActiveRecord::Base
  has_secure_password

  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  validates :password,  :presence     => { :on => :create }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :length =>    { :maximum => 50 }
  validates :email, :presence =>    true,
                    :format =>      { :with => email_regex },
                    :uniqueness =>  { :case_sensitive => false }
  validates :password, :length => { :minimum => 6 }
  validates :invitation_id, :uniqueness => { :allow_nil => true }

  attr_accessible :name, :email, :password, :password_confirmation, :invitation_id


  def salt
    @salt ||= BCrypt::Password.new(password_digest).salt
  end

  def self.authenticate_with_salt(id, salt)
    user = find_by_id(id)
    return nil if user.nil?
    return user if user.salt == salt
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_tokem=(token)
    self.invitation = Invitation.find_by_token(token)
  end

end
