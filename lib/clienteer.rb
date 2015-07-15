require "clienteer/version"
require "clienteer/ingester"
require "clienteer/outgester"
require "clienteer/digester"

require "kiba"
require "mindbody-api"

module Clienteer

  ::MindBody.configure do |config|
    config.site_ids    = ENV["MINDBODY_SITE_IDS"]
    config.source_key  = ENV["MINDBODY_SOURCE_KEY"]
    config.source_name = ENV["MINDBODY_SOURCE_NAME"]
    config.log_level   = :debug # Savon logging level. Default is :debug, options are [:debug, :info, :warn, :error, :fatal]
  end

  def self.call
    $count = 0
    $skipped_people = []
    job_definition = Kiba.parse do
      source Ingester::Mindbody
      transform Digester::IdealProteinCrossReference
      transform Digester::AddressCreation
      transform Digester::PhaseCreation
      destination Outgester::Maliero
    end

    Kiba.run job_definition

    File.open("data/skipped_people", "a+") do |f|
      f.write $skipped_people.join(",")
    end

  end

end
