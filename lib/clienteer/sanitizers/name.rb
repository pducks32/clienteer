
module Clienteer
  module Sanitizer
    class Name

      def process(row)
        names = [row[:raw].first_name, row[:raw].last_name]
        names.any?(&:not_proper?) ? nil : row
      end

      def not_proper?(name)
        return true if name.match /\d/
      end
    end
  end
end
