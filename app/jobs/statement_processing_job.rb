# This job is the entrypoint for the statement processing chain
class StatementProcessingJob < ApplicationJob
  queue_as :default

  def perform(sp, rpc_client)
    client = rpc_client.new("rpc_queue")
    begin
      p "[#{sp.uuid}] Start statement processing job"
      pdf = MiniMagick::Image.read(sp.statement.file.download)
      content = IO.popen([ "gs", "-sDEVICE=txtwrite", "-sOutputFile=-", "-q", "-dNOPAUSE", "-dBATCH", pdf.path ]).read
      response = client.call(sp, content)
      results = JSON.load(response)
      cat, sub = sp.user.uncategorized
      results.each do | result |
        expense = Expense.create!(date: result["date"], raw_description: result["description"], description: result["description"], value: result["value"], statement: sp.statement, user: sp.user, category: cat, subcategory: sub)
        ExpensesHelper.auto_find_category expense
      end
      sp.update(has_succeeded: true)
      sp.statement.file.purge_later
    rescue StandardError => e
      "[#{sp.uuid}] Error: #{e.message}"
      sp.update(has_succeeded: false)
      sp.statement.file.purge_later(wait: 48.hours)
    ensure
      client.stop
      p "[#{sp.uuid}] Statement processing completed"
    end
  end
end
