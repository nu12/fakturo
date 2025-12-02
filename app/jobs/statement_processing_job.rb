# This job is the entrypoint for the statement processing chain
class StatementProcessingJob < ApplicationJob
  queue_as :default

  def perform(sp, rpc_client, cascade = true)
    p "Start statement processing job for #{sp.uuid}"
    pdf = MiniMagick::Image.read(sp.statement.file.download)
    if sp.update(raw: IO.popen([ "gs", "-sDEVICE=txtwrite", "-sOutputFile=-", "-q", "-dNOPAUSE", "-dBATCH", pdf.path ]).read)
      sp.statement.file.purge_later
      RpcJob.perform_later(sp, rpc_client) if cascade
    end
  end
end
