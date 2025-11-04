class ApiAccessesController < ApplicationController
  before_action { set_active_page("access") }
  def edit
  end

  def update
    Current.user.regenerate_token
    if Current.user.save
      redirect_to edit_api_access_path, notice: "Access token was regenerated successfully."
    else
      redirect_to edit_api_access_path, alert: "Error regenerating token."
    end
  end

  def toogle
    Current.user.access_token_enabled = !Current.user.access_token_enabled
    if Current.user.save
      redirect_to edit_api_access_path, notice: "Access token was #{ Current.user.access_token_enabled ? 'enabled' : 'disabled' } successfully."
    else
      redirect_to edit_api_access_path, alert: "Error enabling/disabling token."
    end
  end
end
