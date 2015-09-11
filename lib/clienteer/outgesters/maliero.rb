module Clienteer
  module Outgester
    class Maliero
      def initialize
        @clients = []
      end

      def write(row)
        @clients << new_client(row)
      end

      def new_client(row)
        Client.find_or_create_by(email: row[:raw].email) do |c|
          c.first_name = row[:raw].first_name.capitalize,
          c.last_name = row[:raw].last_name.capitalize
          c.mindbody_id = row[:raw].id.to_s
          c.birthdate = row[:raw].birth_date
          c.gender = row[:raw].gender
          # c.blood_work = row["blood_work"]
          # c.constant_contact = row["constant_contact"]
          c.health_profile = true
          c.ideal_subscription_id = row.fetch("ideal_subscription_id", "").to_s
          c.ideal_protein_subscription = !row.fetch("ideal_subscription_id", "").blank?
          # c.needs_blood_work = row["needs_blood_work"]
          # c.newsletter = row["newsletter"]
          c.notes = row[:raw].notes
          c.phone_number = row[:raw].home_phone || row[:raw].mobile_phone || nil
          c.build_referral
          c.build_fitness_profile
        end
      end

      def close
        Client.transaction do
          success = @clients.map(&:save)
          unless success.all?
            binding.pry
            errored = @clients.select{ |b| !b.errors.blank? }
            errored.each do |e|
              e.save!(validate: false) rescue next
            end
          end
        end
      end
    end
  end
end
