# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'potassium/version'

Gem::Specification.new do |spec|
  spec.name          = "potassium"
  spec.version       = Potassium::VERSION
  spec.authors       = ["juliogarciag"]
  spec.email         = ["julioggonz@gmail.com"]
  spec.summary       = %q{An application generator from Platanus}
  spec.description   = %q{An application generator from Platanus}
  spec.homepage      = "https://github.com/platanus/potassium"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "gli", "~> 2.12.2"
  spec.add_development_dependency "rails", "~> 4.2"
  spec.add_development_dependency "inquirer", "~> 0.2"
end
