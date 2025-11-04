class PasswordsController < ApplicationController
  def edit
  end

  def update
    if Current.user.update(params.permit(:password, :password_confirmation))
      redirect_to edit_user_password_path, notice: "Password has been reset."
    else
      redirect_to edit_user_password_path, alert: "Passwords did not match."
    end
  end
end
