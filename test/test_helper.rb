# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def assert_present(data)
  assert data.present?
end

def assert_blank(data)
  assert data.blank?
end

REDIS_NS = 'testns'.freeze

class RedisSingleton
  require 'redis'
  @@instance = nil

  def initialize
    redis_server = RedisRds.config
    redis_server[:db] = (redis_server[:db]).to_s.to_i
    @@instance = Redis.new(redis_server)
  end

  def self.get_instance
    RedisSingleton.new if @@instance.nil?
    return @@instance
  end

  def self.clear_test_db
    # Clear test keys from Redis before running tests
    redis = get_instance
    redis.flushdb if Rails.env.test?
  end
end

RedisRds.configure(connection: RedisSingleton.get_instance, namespace: REDIS_NS)
