$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'redis_rds/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redis_rds'
  s.version     = RedisRds::VERSION
  s.authors     = ['Checkitmobile GmbH']
  s.email       = ['support@barcoo.com']
  s.homepage    = 'https://www.barcoo.com'
  s.summary     = 'Ruby data structures stored in Redis.'
  s.description = 'RedisRds provides Ruby interfaces for data structures like String or Hash stored in Redis.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '< 5'
  s.add_dependency 'redis', '~> 3.2'
  s.add_development_dependency 'sqlite3'
end
