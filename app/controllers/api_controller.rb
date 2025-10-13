class ApiController < ApplicationController
  before_action :set_user
  def all
    
    sql = ActiveRecord::Base.send(:sanitize_sql_array, ["select 
      expenses.date,
      expenses.value, 
      subcategories.name as subcategory,
      categories.name as category
      from expenses 
      left join subcategories on expenses.subcategory_id = subcategories.id
      left join categories on subcategories.category_id = categories.id
      left join documents on expenses.document_id = documents.id
      where documents.user_id = ?", @user.id])
    result = ActiveRecord::Base.connection.execute(sql)   
    render json: result
  end

  private
  def set_user
    current_user = User.where(uuid: params["uuid"], access_token: params["access_token"], access_token_enabled: true).where("access_token_expiry_date >= ?", Time.now).first
    p current_user
    if !current_user
      render json: :forbidden, status: :forbidden
      return
    end
    @user = current_user
  end
end
