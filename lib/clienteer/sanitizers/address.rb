
module Clienteer
  module Sanitizer
    class Address

      def process(row)
        if valid_zip_code? row["address"]
          clean_state row["address"]
          return row
        else
          row[:reason] = "zip code invalid"
          $skipped_people << row
          return nil
        end
      end

      def valid_zip_code?(address)
        address.zip_code && address.zip_code.to_s.match(/\A\d{5}(-\d{4})?\Z/)
      end

      def clean_state(address)
        address.state = "Illinois" if address.state && address.state.match(/il/i)
      end
    end
  end
end
