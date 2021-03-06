# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pocketbeuter/version'

Gem::Specification.new do |spec|
  spec.name          = "pocketbeuter"
  spec.version       = Pocketbeuter::VERSION
  spec.authors       = ["Piotr Król"]
  spec.email         = ["pietrushnic@gmail.com"]
  spec.description   = %q{command line interface to Pocket}
  spec.summary       = %q{command line interface to Pocket}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency "thor"
  spec.add_development_dependency "colorize"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "coveralls"
end
