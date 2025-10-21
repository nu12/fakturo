# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

task :version do
  sem_ver = "v%d.%d.%d" % [
    Fakturo::Application.config.version[:major],
    Fakturo::Application.config.version[:minor],
    Fakturo::Application.config.version[:patch]
  ]

  p Fakturo::Application.config.version[:build] > 0 ? "%s+%d" % [ sem_ver, Fakturo::Application.config.version[:build] ] : sem_ver
end
