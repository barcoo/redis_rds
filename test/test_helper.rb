$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'redis_rds'

require 'minitest/autorun'

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
    redis.flushdb
  end
end

RedisRds.configure(connection: RedisSingleton.get_instance, namespace: REDIS_NS)

module ActiveSupport
  class TestCase
    self.test_order = :random
    def setup
      super
      RedisSingleton.clear_test_db
    end
  end
end
