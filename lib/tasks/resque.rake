

namespace :resque do
  desc 'run workers for all queues'
  task :run => :environment do

    require 'resque/tasks'
    ENV['QUEUES'] ||= '*'

    Rake::Task['resque:work'].invoke
  end
end

