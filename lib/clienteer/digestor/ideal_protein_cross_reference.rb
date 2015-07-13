require "json"

module Clienteer
  module Digestor
    class IdealProteinCrossReference
      def initialize
        @data = JSON.parse File.read("data/ideal_protein.clean.json")
        optimized_data
      end

      def optimized_data
        @optimized_data ||= @data.group_by { |c| c["last_name"][0] }
      end

      def process(row)
        ideal_protein_client = find_ideal_protein_client(row)
        return nil if person.nil?
        row.tap do |r|
          r["ideal_subscription_id"] = person["ideal_subscription_id"]
          r["phase"] = person["phase"]
          r["ideal_protein_birthday"] = person["birthday"]
        end
      end

      def find_ideal_protein_client(row)
        person = find_by_email(row["raw"].email) || find_by_name(last: row["raw"].last_name, first: row["raw"].first_name) || ask_for_verification(row)
      end

      def find_by_name(first:, last:)
        first_letter = last[0]
        @optimized_data[first_letter].find { |r| r["first_name"] == first && r["last_name"] == last }
      end

      def find_by_email(email)
        @data.find { |c| c["email"] == email }
      end

      def ask_for_verification(row)
        # text = []
        # text << "\tVerification\t\t".underline.light_red.bold
        # text << "There was a problem matching #{row['full_name']} with an ideal protein client.".light_black
        # text << ""
        # text << "The client's data is:" + "#{row.inspect}".cyan
        # text << "Should I skip this person or not?".magenta.bold
        # print text.join("\n")
        # bool = IO.gets.chomp!.include?("y")
        $skipped_people << row["raw"].id
      end

    end
  end
end
