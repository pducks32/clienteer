require "pry"
module Clienteer
  module Digestor
    class PhaseCreation
      def initialize
      end

      def process(row)
        $count += 1
        binding.pry unless $count >= 20
        row["phase"] = Phase.where(number: row["phase"]).first
        row
      end
    end
  end
end
