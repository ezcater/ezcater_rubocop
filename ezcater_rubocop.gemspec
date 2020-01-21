# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ezcater_rubocop/version"

Gem::Specification.new do |spec|
  spec.name          = "ezcater_rubocop"
  spec.version       = EzcaterRubocop::VERSION
  spec.authors       = ["ezCater, Inc"]
  spec.email         = ["engineering@ezcater.com"]

  spec.summary       = "ezCater custom cops and shared configuration"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/ezcater/ezcater_rubocop"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  excluded_files = %w(.circleci/config.yml
                      .gitignore
                      .rspec
                      .rubocop.yml
                      .ruby-gemset
                      .ruby-version
                      .travis.yml
                      bin/console
                      bin/setup
                      Rakefile)

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(/^(test|spec|features)\//)
  end - excluded_files
  spec.bindir = "bin"
  spec.executables << "circle_rubocop.rb"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "mry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "simplecov"

  spec.add_runtime_dependency "parser", "!= 2.5.1.1"
  spec.add_runtime_dependency "rubocop", "~> 0.78.0"
  spec.add_runtime_dependency "rubocop-rails", "~> 2.4.1"
  spec.add_runtime_dependency "rubocop-rspec", "~> 1.37.1"
end
