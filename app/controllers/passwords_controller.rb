class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      user.generate_password_reset_token!
      PasswordsMailer.reset(user).deliver_later
  
      if Rails.env.development?
        token = user.signed_id(purpose: "password_reset", expires_in: 15.minutes)
        flash[:reset_link] = edit_password_url(token: token)
      end
    end
  
    redirect_to root_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end
  

  def edit
  end

  def update
    if @user.reset_password!(params[:password], params[:password_confirmation])
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
  def set_user_by_token
    @user = User.find_signed!(params[:token], purpose: "password_reset")
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
  end
end
