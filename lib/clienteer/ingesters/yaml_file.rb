require 'ruby-progressbar'
module Clienteer
  module Ingester
    class YAMLFile

      def self.get_clients
        YAML.load_file("data/mindbody.yaml")
      end

      def initialize
        @clients = YAMLFile.get_clients
        $progressbar = ProgressBar.create total: @clients.length, format: '%a %bᗧ%i %p%% %t', progress_mark: ' ', remainder_mark: '･'
      end

      def each
        @clients.each do |c|
          $progressbar.increment
          yield c
        end
      end
    end
  end
end
