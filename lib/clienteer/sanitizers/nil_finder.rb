
module Clienteer
  module Sanitizer
    class NilFinder

      def process(row)
        raw = row[:raw]
        attrs = [row, raw, raw.first_name, raw.last_name, raw.email]
        if contains_nils? attrs
          row[:reason] = "contains nils"
          $skipped_people << row
          return nil
        else
          return row
        end
      end

      def contains_nils?(attrs)
        attrs.any? {|a| a.nil? }
      end
    end
  end
end
