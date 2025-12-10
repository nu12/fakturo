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
        sp.statement.expenses << Expense.create!(date: result["date"], description: result["description"], value: result["value"], statement: sp.statement, user: sp.user, category: cat, subcategory: sub)
      end
      sp.update(has_succeeded: true)
    rescue
      "[#{sp.uuid}] Error"
      sp.update(has_succeeded: false)
    ensure
      sp.statement.file.purge_later
      client.stop
      p "[#{sp.uuid}] Statement processing completed"
    end
  end
end
