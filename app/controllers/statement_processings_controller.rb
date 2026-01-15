class StatementProcessingsController < ApplicationController
  before_action :set_statement_processing
  def update
    unless @sp.statement.file.attached?
      redirect_to @sp.statement, alert: "Statement file has already been deleted.", status: :see_other
      return
    end

    if @sp.has_succeeded
      redirect_to @sp.statement, alert: "Statement has already been sucessfully processed.", status: :see_other
      return
    end

    @sp.update(has_succeeded: nil)
    StatementProcessingJob.perform_later @sp, Rpc::Client::StatementProcessingRpcClient
    redirect_to @sp.statement, notice: "Processing was successfully rescheduled.", status: :found
  end

  private
  def set_statement_processing
      params.permit(:id)
      @sp = StatementProcessing.find(params[:id])
      authorize @sp
    end
end
