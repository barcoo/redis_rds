# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

def assert_present data
  assert data.present?
end

def assert_blank data
  assert data.blank?
end

REDIS_NS = "testns"

class RedisSingleton
  require "redis"
  @@instance = nil

  def initialize
    redis_server = {:host=>"localhost", :db=>1, :port=>6379, :timeout=>30, :thread_safe=>true}
    redis_server[:db] = "#{redis_server[:db]}".to_i
    @@instance = Redis.new(redis_server)
  end

  def self.get_instance
    RedisSingleton.new if @@instance.nil?
    return @@instance
  end

  def self.clear_test_db
    # Clear test keys from Redis before running tests
    redis = get_instance()
    if Rails.env.test?
      redis.flushdb
    end
  end
end

RedisRds::Object.configure({connection: RedisSingleton.get_instance, namespace: REDIS_NS})
