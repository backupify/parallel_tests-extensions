# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parallel_tests/extensions/version'

Gem::Specification.new do |spec|
  spec.name          = "parallel_tests-extensions"
  spec.version       = ParallelTests::Extensions::VERSION
  spec.authors       = ["Josh Bodah"]
  spec.email         = ["jb3689@yahoo.com"]

  spec.summary       = %q{helper methods for working with parallel_tests}
  spec.description   = %q{helper methods for working with parallel_tests. adds hooks and more user friendly boolean methods}
  spec.homepage      = "https://github.com/backupify/parallel_tests-extensions"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'parallel_tests'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
