# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel/record_loader/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel-record_loader"
  spec.version       = Sequel::RecordLoader::VERSION
  spec.authors       = ["Herre Groen"]
  spec.email         = ["herregroen@gmail.com"]
  spec.summary       = "loads record definitions from a JSON or YAML file and synchronizes them to the database."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
