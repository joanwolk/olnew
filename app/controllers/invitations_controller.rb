class InvitationsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user


  def new
    @title = "Invite users"
    @invitation = Invitation.new
  end

  def create
    @title = "Invite users"
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user
    if @invitation.save
      Mailer.invite(@invitation).deliver
      @invitation.update_attributes(sent_at: Time.now)
      flash[:success] = "Invitation sent."
      redirect_to new_invitation_path
    else
      @title = "Invite users"
      render 'new'
    end
  end


  private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def authenticate
      deny_access unless signed_in?
      # deny_access defined in SessionsHelper
    end

end
