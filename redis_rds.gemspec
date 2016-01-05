$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "redis_rds/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "redis_rds"
  s.version     = RedisRds::VERSION
  s.authors     = ["Checkitmobile GmbH"]
  s.email       = ["support@barcoo.com"]
  s.homepage    = "http://www.barcoo.com"
  s.summary     = "Summary of RedisRds."
  s.description = "Description of RedisRds."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.1.1"
  s.add_dependency "redis", "~> 3.2"
  s.add_development_dependency "sqlite3"
end
