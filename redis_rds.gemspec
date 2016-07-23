# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_rds/version'

Gem::Specification.new do |spec|
  spec.name          = 'redis_rds'
  spec.version       = RedisRds::VERSION
  spec.authors       = ['Checkitmobile GmbH']
  spec.email         = ['support@barcoo.com']

  spec.summary       = 'Ruby data structures stored in Redis.'
  spec.description   = 'RedisRds provides Ruby interfaces for data structures like String or Hash stored in Redis.'
  spec.homepage      = 'https://github.com/barcoo/redis_rds'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'redis', '~> 3.2'
  spec.add_dependency 'activesupport', '~> 4'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
end
