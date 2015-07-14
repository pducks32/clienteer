
module Clienteer
  module Sanitizers
    class NilFinder

      def process(row)
        raw = row[:raw]
        attrs = row, raw, raw.first_name, raw.last_name, raw.email
        return nil if contains_nils? attrs
        row
      end

      def contains_nils?(attrs)
        attrs.any? {|a| a.nil? }
      end
    end
  end
end
