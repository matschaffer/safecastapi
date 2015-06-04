class ProfilesController < ApplicationController

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to :dashboard, :locale => @user.default_locale
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :time_zone, :default_locale)
  end

end
