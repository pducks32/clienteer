require "pry"
module Clienteer
  module Digester
    class PhaseCreation
      def initialize
      end

      def process(row)
        row["phase"] = Phase.where(number: row["phase"]).first
        row
      end
    end
  end
end
