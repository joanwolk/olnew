class SessionsController < ApplicationController
  before_filter :signed_in?, :only => [:delete]


  def new
    @title = "Sign in"
  end

  def create
    user = User.find_by_email(params[:session][:email]).try(:authenticate, params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid user/password combination."
      @title = "Sign in"
      render :new
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
