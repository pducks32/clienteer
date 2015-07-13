
module Clienteer
  module Digestor
    class PhaseCreation
      def initialize
      end

      def process(row)
        row["phase"] = Phase.find(number: row["phase"])
      end
    end
  end
end
