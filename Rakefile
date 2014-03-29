# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Manatee::Application.load_tasks


Rake::Task[:test].prerequisites.clear
task :test => [:spec]
Rake::Task[:default].prerequisites.clear
task :default => [:spec]