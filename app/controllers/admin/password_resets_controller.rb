class Admin::PasswordResetsController < ApplicationController
  no_login_required
  skip_before_filter :verify_authenticity_token

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to welcome_path, :notice => "Email sent with password reset instructions."
    else
      redirect_to welcome_path, :notice => "Email not registered. Double check your spelling or seek out your Admin."
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to welcome_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end