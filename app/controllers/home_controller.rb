class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @active = "home"
  end

  def policy
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Data & Privacy policy" } ]
    @active = "policy"
    render("guest/policy")
  end

  def password
  end

  def delete
  end

  def destroy
    if current_user.destroy
      redirect_to new_user_session_path, notice: "All user data was erased. See you next time."
    end
  end

  def access
    @active = "access"
  end

  def access_regenerate
    current_user.regenerate_token
    if current_user.save
      redirect_to user_access_path, notice: "Access token was regenerated successfully."
    else
      redirect_to user_access_path, alert: "Error regenerating token."
    end
  end

  def access_toogle
    current_user.access_token_enabled = !current_user.access_token_enabled
    if current_user.save
      redirect_to user_access_path, notice: "Access token was #{ current_user.access_token_enabled ? 'enabled' : 'disabled' } successfully."
    else
      redirect_to user_access_path, alert: "Error enabling/disabling token."
    end
  end
end
