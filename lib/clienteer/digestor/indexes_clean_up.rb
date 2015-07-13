module Clienteer
  module Digestor
    class IndexesCleanUp
      def initialize
      end

      def process(row)
        row["health_profile"] = get_index("health_profile", row: row)
        row["blood_work"] = get_index("blood_work", row: row)
      end

      def get_index(attr, row: )
        indexes = row["indexes"]
        if indexes.is_a? Hash
          if indexes[:name] == row
            return pull_out_attr from: indexes
          end
        else
          index = indexes.find { |i| i[:name] == row }
          return pull_out_attr from: index
        end
        nil
      end

      private

      def pull_out_attr(from: index)
        from[:values][:client_index_value][:name]
      end
    end
  end
end
