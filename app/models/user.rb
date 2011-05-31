class User < ActiveRecord::Base
  has_secure_password
  validates :password,  :presence     => { :on => :create }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :length =>    { :maximum => 50 }
  validates :email, :presence =>    true,
                    :format =>      { :with => email_regex },
                    :uniqueness =>  { :case_sensitive => false }
  validates :password, :length => { :minimum => 6 }


  def salt
    @salt ||= BCrypt::Password.new(password_digest).salt
  end

  def self.authenticate_with_salt(id, salt)
    user = find_by_id(id)
    return nil if user.nil?
    return user if user.salt == salt
  end

end
