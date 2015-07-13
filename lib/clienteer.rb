require "clienteer/version"
require "clienteer/ingestor"
require "clienteer/outgestor"

require "mindbody-api"

module Clienteer

  MindBody.configure do |config|
    config.site_ids    = ENV["MINDBODY_SITE_ID"]
    config.source_key  = ENV["MINDBODY_SOURCE_KEY"]
    config.source_name = ENV["MINDBODY_SOURCE_NAME"]
    config.log_level   = :debug # Savon logging level. Default is :debug, options are [:debug, :info, :warn, :error, :fatal]
  end

  def call
    $skipped_people = []
    job_definition = Kiba.parse do
      source Ingestor::Mindbody
      transform Digestor::IdealProteinCrossReference
      transform Digestor::AddressCreation
      transform Digestor::PhaseCreation
      destination Outgestor::Maliero
    end

    Kiba.run job_definition

    File.open("data/skipped_people" "a+") do |f|
      f.write $skipped_people.join(",")
    end
  end

end
