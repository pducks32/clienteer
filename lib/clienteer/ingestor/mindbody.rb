require 'ruby-progressbar'
module Clienteer
  module Ingestor
    class Mindbody
      def initialize
        $progressbar = ProgressBar.create total: clients.length, format: '%a %bᗧ%i %p%% %t', progress_mark: ' ', remainder_mark: '･'
      end

      def clients
        @clients ||= MindBody::Services::ClientService.get_clients("UserCredentials"  => hash, "SearchText" => "").result
      end

      def each
        clients.each do |c|
          $progressbar.increment
          yield {raw: c} unless c.first_name.include?(" ") || c.last_name.include?(" ")
        end
      end
    end
  end
end
