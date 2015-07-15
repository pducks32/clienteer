
module Clienteer
  module Sanitizer
    class Address

      def process(row)
        address = row["address"]
        return nil unless check_zip_code address
        clean_state address
        row
      end

      def check_zip_code(address)
        address.zip_code.match /\A\d{5}(-\d{4})?\Z/
      end

      def clean_state(address)
        address.state = "Illinois" if address.state.match /il/i
      end
    end
  end
end
