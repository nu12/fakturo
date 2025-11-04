class RegistrationsController < ApplicationController
  layout "guest"
  allow_unauthenticated_access only: %i[ new create ]
  def create
    @user = User.new(params.permit(:username, :password, :password_confirmation))
    if @user.save
      redirect_to root_path, notice: "User registred successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  def delete
  end

  def destroy
    if Current.user.destroy
      redirect_to new_session_path, notice: "All user data was erased. See you next time."
    end
  end
end
