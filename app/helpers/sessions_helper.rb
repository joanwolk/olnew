module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.password_digest]
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !!current_user
  end

  def signed_out?
    !user_signed_in?
  end


  private

    def user_from_remember_token
      User.authenticate_cookie(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end