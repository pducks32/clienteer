
module Clienteer
  class Railtie < Rails::Railtie
    rake_tasks do
      namespace :clienteer do
        desc "Collect MindBody information to YAML file"
        task collect: :environment do
          Clienteer::Ingester::MindBody.to_file
        end

        namespace :run do
          desc "Run Clienteer from mindbody.yml"
          task file: :environment do
            Clienteer.call ingestor: Clienteer::Ingester::YAMLFile
          end

          desc "Run Clienteer from new data"
          task fresh: :collect do
            Clienteer.call
          end
        end
      end
    end
  end
end
