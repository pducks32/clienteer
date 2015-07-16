
module Clienteer
  module Sanitizer
    class Name

      def process(row)
        names = [row[:raw].first_name, row[:raw].last_name].compact
        if names.length == 1 && names[0].include? (" ")
          names = names[0].split(" ")
          row[:raw].first_name, row[:raw].last_name = *names
          return row if names.all? {|n| proper? n }
        end
        return remove(row)
      end

      def proper?(name)
        !name.match /\d/
      end

      def remove(row)
        row[:reason] = "names not valid"
        $skipped_people << row
        nil
      end
    end
  end
end
