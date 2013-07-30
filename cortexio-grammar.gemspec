# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cortexio-grammar/version'

Gem::Specification.new do |spec|
  spec.name          = "cortexio-grammar"
  spec.version       = CortexIO::Grammar::VERSION
  spec.authors       = ["Preston Lee"]
  spec.email         = ["preston.lee@prestonlee.com"]
  spec.description   = %q{A proof-of-concept CortexIO Query Language grammar using Ruby and citrus.}
  spec.summary       = %q{A proof-of-concept grammar.}
  spec.homepage      = "http://github.com/preston/cortexio-grammar"
  spec.license       = "Apache 2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "citrus"
  spec.add_development_dependency "minitest"
end
