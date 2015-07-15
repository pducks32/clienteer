
module Clienteer
  class Railtie < Rails::Railtie
    rake_tasks do
      desc "Runs clienteer"
      task :clienteer => :environment do
        Clienteer.call
      end
    end
  end
end
