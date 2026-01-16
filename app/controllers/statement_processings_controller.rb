class StatementProcessingsController < ApplicationController
  before_action :set_statement_processing
  def update
    if @sp.retry
      redirect_to @sp.statement, notice: "Processing was successfully rescheduled.", status: :found
    else
      redirect_to @sp.statement, alert: @sp.errors.where(:base).first.full_message, status: :see_other
    end
  end

  private
  def set_statement_processing
      params.permit(:id)
      @sp = StatementProcessing.find(params[:id])
      authorize @sp
    end
end
