# This job is the entrypoint for the statement processing chain
class StatementProcessingJob < ApplicationJob
  queue_as :default

  def perform(sp)
    pdf = MiniMagick::Image.read(sp.statement.file.download)
    sp.raw = IO.popen([ "gs", "-sDEVICE=txtwrite", "-sOutputFile=-", "-q", "-dNOPAUSE", "-dBATCH", pdf.path ]).read
    if sp.save
      sp.statement.file.purge
    end
  end
end
