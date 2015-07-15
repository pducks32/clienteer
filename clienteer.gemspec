# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clienteer/version'

Gem::Specification.new do |spec|
  spec.name          = "clienteer"
  spec.version       = Clienteer::VERSION
  spec.authors       = ["Patrick Metcalfe"]
  spec.email         = ["git@patrickmetcalfe.com"]

  spec.summary       = %q{Kiba for a legacy client system.}
  spec.homepage      = "http://maliero.herokuapp.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "kiba"
  spec.add_dependency "ruby-progressbar"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
