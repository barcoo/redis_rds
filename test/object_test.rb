require 'test_helper'

module RedisRds
	class ObjectTest < ActiveSupport::TestCase

		def setup
			super
			RedisSingleton.clear_test_db
			@test_key = 'testkey'
			@object = RedisRds::Object.new(@test_key)
		end

		def test_initialize
			assert @object.redis_key.starts_with?(REDIS_NS)
			assert !!(@object.redis_key =~ /^.+#{@test_key}.*$/)
		end

		def test_delete
			@object.delete
			assert !@object.exists?
		end

		def test_type
			assert_equal 'none', @object.type
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			assert_equal 'string', @object.type
		end

		def test_expire
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			@object.expire(10)
			assert @object.ttl > 0 && @object.ttl <= 10
		end

		def test_expireat
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			@object.expireat(10.seconds.from_now)
			assert @object.ttl > 0 && @object.ttl <= 10
		end

		def test_exists?
			assert !@object.exists?
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			assert @object.exists?
		end

		def test_persist
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			@object.expire(10)
			assert @object.ttl > 0 && @object.ttl <= 10
			@object.persist
			assert @object.ttl == -1
		end

		def test_ttl
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			assert @object.ttl == -1
			@object.expire(10)
			assert @object.ttl > 0 && @object.ttl <= 10
		end

		def test_pttl
			RedisSingleton.get_instance.set(@object.redis_key, 'string_value')
			assert @object.ttl == -1
			@object.expire(10)
			assert @object.pttl > 1000 && @object.pttl <= 10000
		end
	end
end