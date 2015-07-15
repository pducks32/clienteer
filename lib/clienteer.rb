require "clienteer/version"
require "clienteer/ingester"
require "clienteer/outgester"
require "clienteer/digester"
require "clienteer/sanitizer"

require "kiba"
require "mindbody-api"
require "json"

require 'clienteer/railtie' if defined?(Rails)

require 'dotenv'
Dotenv.load

module Clienteer

  ::MindBody.configure do |config|
    config.site_ids    = ENV["MINDBODY_SITE_IDS"]
    config.source_key  = ENV["MINDBODY_SOURCE_KEY"]
    config.source_name = ENV["MINDBODY_SOURCE_NAME"]
    config.log_level   = :debug # Savon logging level. Default is :debug, options are [:debug, :info, :warn, :error, :fatal]
  end

  def self.call(ingestor: Ingester::Mindbody)
    $skipped_people = []
    job_definition = Kiba.parse do
      source ingestor
      transform Sanitizer::NilFinder
      transform Sanitizer::Name
      transform Digester::IdealProteinCrossReference
      transform Digester::AddressCreation
      transform Sanitizer::Address
      transform Digester::PhaseCreation
      destination Outgester::Maliero
    end

    Kiba.run job_definition

    File.open("data/skipped_people.yaml", "a+") do |f|
      f.write YAML.dump $skipped_people
    end

  end

end
