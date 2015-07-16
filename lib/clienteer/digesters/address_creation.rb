
module Clienteer
  module Digester
    class AddressCreation
      def initialize
      end

      def process(row)
        row["address"] = Address.new(first_line: row[:raw].address_line1, second_line: row[:raw].address_line2, city: row[:raw].city.capitalize, state: row[:raw].state, zip_code: row[:raw].postal_code)
        row
      end
    end
  end
end
