# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'osm/version'

Gem::Specification.new do |spec|
  spec.name          = "osm"
  spec.version       = Osm::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Venkat-RK"]
  spec.email         = ["venkat.rk4@gmail.com"]

  spec.summary       = %q{osm}
  spec.description   = %q{osm}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "rack", "~> 1.6.4"
  spec.add_dependency "sinatra", "~> 1.4.7"
  spec.add_dependency "sidekiq", "~> 4.1.2"
  spec.add_dependency "redis", "~> 3.3.0"
  spec.add_dependency "connection_pool", "~> 2.2.0"
  spec.add_dependency "redis-objects", "~> 1.2.1"
  spec.add_dependency "activesupport", '~> 4.2'

end
