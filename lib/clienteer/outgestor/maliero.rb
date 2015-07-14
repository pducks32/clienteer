module Clienteer
  module Outgestor
    class Maliero
      def initialize
        @clients = []
      end

      def write(row)
        $progressbar.increment
        @clients << new_client(row)
      end

      def new_client(row)
        Client.new do |c|
          c.mindbody_id = row[:raw].id.to_s
          c.birthdate = row[:raw].birth_date
          c.gender = row[:raw].gender
          # c.blood_work = row["blood_work"]
          # c.constant_contact = row["constant_contact"]
          c.email = row[:raw].email
          c.first_name = row[:raw].first_name
          # c.health_profile = row["health_profile"]
          c.ideal_subscription_id = row["ideal_subscription_id"].to_s
          c.ideal_protein_subscription = !row["ideal_subscription_id"].nil?
          c.last_name = row[:raw].last_name
          # c.needs_blood_work = row["needs_blood_work"]
          # c.newsletter = row["newsletter"]
          c.notes = row[:raw].notes
          c.phase = row["phase"]
          c.phone_number = row[:raw].home_phone || row[:raw].mobile_phone || nil
          c.address = row["address"]
        end
      end

      def close
        $stderr.puts "\n\n\nHELLO\n\n\n\n"
        binding.pry
        Client.transaction do
          success = @clients.map(&:save)
          unless success.all?
            binding.pry
            errored = @clients.select{ |b| !b.errors.blank? }
            errored.each do |e|
              e.save!(validate: false)
            end
            # do something with the errored values
            raise ActiveRecord::Rollback
          end
        end
      end
    end
  end
end
