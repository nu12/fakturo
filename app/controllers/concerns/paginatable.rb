class Paginatable
  def initialize(defaults = {})
    @defaults = defaults
  end

  def call(mapper, options = {})
    options = @defaults.merge(options)
    mapper.get "(/page/:page)", action: options[:action], as: "page"
  end
end
