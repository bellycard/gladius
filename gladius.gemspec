# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gladius/version"

Gem::Specification.new do |spec|
  spec.name          = "gladius"
  spec.version       = Gladius::VERSION
  spec.authors       = ["Carl Thuringer"]
  spec.email         = ["carlthuringer@gmail.com"]

  spec.summary       = "Gladius Cuts Through JSONAPI"
  spec.description   = "Gladius is a browser and client for JSONAPI services."
  spec.homepage      = "https://github.com/bellycard/gladius"
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.11.0"
  spec.add_dependency "addressable", "~> 2.5.0"
  # spec.add_dependency "faraday_middleware", "~> 0.11.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "database_cleaner", "~> 1.5.3"
  spec.add_development_dependency "jsonapi-resources", "~> 0.9.0"
  spec.add_development_dependency "railties", "~> 5.0.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2.3"
  spec.add_development_dependency "pronto", "~> 0.8.0"
  spec.add_development_dependency "pronto-rubocop", "~> 0.8.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.13"
end
