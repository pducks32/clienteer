require 'ruby-progressbar'
module Clienteer
  module Ingester
    class Mindbody

      def self.get_clients
        hash = {"Username" => ENV["MINDBODY_USERNAME"], "Password" => ENV["MINDBODY_PASSWORD"], "SiteIDs" => {"int" => ENV["MINDBODY_SITE_IDS"]}}
        alpha = ::MindBody::Services::ClientService.get_clients("UserCredentials"  => hash, "SearchText" => "")
        alpha.result[:clients]
      end

      def self.to_file
        File.open('data/mindbody.yml', 'w') do |file|
          file.write(YAML.dump(Mindbody.get_clients))
        end
      end

      def initialize
        $progressbar = ProgressBar.create total: 2059, format: '%a %bᗧ%i %p%% %t', progress_mark: ' ', remainder_mark: '･'
        @clients = Mindbody.get_clients
      end

      def each
        @clients.each do |c|
          $progressbar.increment
          object = {raw: c}
          yield object
        end
      end
    end
  end
end
