class User < ActiveRecord::Base
  has_secure_password
  validates :password,  :presence     => { :on => :create }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :length =>    { :maximum => 50 }
  validates :email, :presence =>    true,
                    :format =>      { :with => email_regex },
                    :uniqueness =>  { :case_sensitive => false }
  validates :password, :length => { :minimum => 6 }


  def self.authenticate_cookie(id, password_digest)
    user = find_by_id(id)
    return nil if user.nil?
    return user if user.password_digest == password_digest
  end

end
