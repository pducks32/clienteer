
module Clienteer
  module Digester
    class IdealProteinCrossReference
      def initialize
        @data = JSON.parse File.read("data/ideal_protein.clean.json")
        optimized_data
      end

      def optimized_data
        @optimized_data ||= @data.group_by do |c|
          ln = c["last_name"]
        end
      end

      def process(row)
        person = find_ideal_protein_client(row)
        if person.nil?
          row[:reason] = "ideal protein subscription not found"
          $skipped_people << row
          return nil
        end
        row.tap do |r|
          r["ideal_subscription_id"] = person["ideal_subscription_id"].to_i
          r["phase"] = person["phase"].to_i
          r["ideal_protein_birthday"] = person["birthday"]
        end
      rescue
        $stderr.puts(row.inspect)
        raise
      end

      def find_ideal_protein_client(row)
        person = find_by_email(row[:raw].email) || find_by_name(last: row[:raw].last_name, first: row[:raw].first_name) || ask_for_verification(row)
      end

      def find_by_name(first:, last:)
        first_letter = last[0]
        if @optimized_data[first_letter].nil?
          @data.find { |r| r["first_name"].downcase == first.downcase && r["last_name"].downcase == last.downcase }
        else
          @optimized_data.find { |r| r["first_name"].downcase == first.downcase && r["last_name"].downcase == last.downcase }
        end
      end

      def find_by_email(email)
        @data.find { |c| c["email"].downcase == email.downcase }
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
        nil
      end

    end
  end
end
