class HomeController < ApplicationController
  def index
    @active = "home"
  end

  def policy
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Data & Privacy policy" } ]
    @active = "policy"
    render("guest/policy")
  end

  def delete
  end

  def destroy
    if Current.user.destroy
      redirect_to new_session_path, notice: "All user data was erased. See you next time."
    end
  end

  def access
    @active = "access"
  end

  def access_regenerate
    Current.user.regenerate_token
    if Current.user.save
      redirect_to user_access_path, notice: "Access token was regenerated successfully."
    else
      redirect_to user_access_path, alert: "Error regenerating token."
    end
  end

  def access_toogle
    Current.user.access_token_enabled = !Current.user.access_token_enabled
    if Current.user.save
      redirect_to user_access_path, notice: "Access token was #{ Current.user.access_token_enabled ? 'enabled' : 'disabled' } successfully."
    else
      redirect_to user_access_path, alert: "Error enabling/disabling token."
    end
  end
end
