require 'ruby-progressbar'
module Clienteer
  module Ingestor
    class Mindbody
      def initialize
        $progressbar = ProgressBar.create total: 2059, format: '%a %bᗧ%i %p%% %t', progress_mark: ' ', remainder_mark: '･'
        @clients = get_clients
      end

      def get_clients
        hash = {"Username" => ENV["MINDBODY_USERNAME"], "Password" => ENV["MINDBODY_PASSWORD"], "SiteIDs" => {"int" => ENV["MINDBODY_SITE_IDS"]}}
        alpha = ::MindBody::Services::ClientService.get_clients("UserCredentials"  => hash, "SearchText" => "")
        alpha.result[:clients]
      end

      def each
        @clients.each do |c|
          object = {raw: c}
          unless c.first_name.nil? || c.last_name.nil? || c.first_name.include?(" ") || c.last_name.include?(" ") || c.first_name.include?("0") || c.email.nil? || c.nil?
            yield object
          end
        end
      end
    end
  end
end
