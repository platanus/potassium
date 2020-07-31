# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'potassium/version'

Gem::Specification.new do |spec|
  spec.name          = "potassium"
  spec.version       = Potassium::VERSION
  spec.authors       = ["juliogarciag"]
  spec.email         = ["julioggonz@gmail.com"]
  spec.summary       = "An application generator from Platanus"
  spec.description   = "An application generator from Platanus"
  spec.homepage      = "https://github.com/platanus/potassium"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rubocop", Potassium::RUBOCOP_VERSION
  spec.add_development_dependency "rubocop-rspec"
  spec.add_runtime_dependency "gems", "~> 0.8"
  spec.add_runtime_dependency "gli", "~> 2.12.2"
  spec.add_runtime_dependency "inquirer", "~> 0.2"
  spec.add_runtime_dependency "levenshtein", "~> 0.2"
  spec.add_runtime_dependency "rails", Potassium::RAILS_VERSION
  spec.add_runtime_dependency "semantic", "~> 1.4"
end
