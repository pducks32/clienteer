
module Clienteer
  module Sanitizer
    class Name

      def process(row)
        names = [row[:raw].first_name, row[:raw].last_name]
        names = names.compact.split(" ") if names.compact.length == 1
        if names.all? {|n| proper? n }
          return row
        else
          row[:reason] = "names not valid"
          $skipped_people << row
          return nil
        end
      end

      def proper?(name)
        return false if name.match /\d/
      end
    end
  end
end
