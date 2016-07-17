require 'test_helper'

module RedisRds
  class MutexTest < ActiveSupport::TestCase
    def setup
      super
      RedisSingleton.clear_test_db
    end

    def test_mutex_concurrency
      mutex_1 = RedisRds::Mutex.new('test')
      mutex_2 = RedisRds::Mutex.new('test')

      assert mutex_1.lock
      assert !mutex_2.lock
      mutex_1.release
      assert mutex_2.lock
      assert !mutex_1.lock
    end

    def test_mutex_no_concurrency
      mutex_1 = RedisRds::Mutex.new('test_1')
      mutex_2 = RedisRds::Mutex.new('test_2')

      assert mutex_1.lock
      assert mutex_2.lock
    end

    def test_ownership
      mutex_1 = RedisRds::Mutex.new('test', 2.minutes, 'a')
      mutex_2 = RedisRds::Mutex.new('test', 2.minutes, 'a')
      mutex_3 = RedisRds::Mutex.new('test', 2.minutes, 'b')

      assert mutex_1.lock
      assert mutex_2.lock
      assert !mutex_3.lock
      mutex_2.release
      assert mutex_3.lock
      assert !mutex_1.release
    end
  end
end
