require 'test_helper'

module RedisRds
	class ExpirableHashTest < ActiveSupport::TestCase

		def setup
			super
			RedisSingleton.clear_test_db
			@test_key = 'test'
			@hash = RedisRds::ExpirableHash.new(@test_key)
		end

		def test_get_set_setex
			assert_blank @hash.get('test')
			@hash.set('test', '1')
			assert_equal '1', @hash.get('test')
			@hash.setex('test', '1', 1)
			sleep 1.1
			assert_blank @hash.get('test')
		end

		def test_expiry_key
			expiry_key = @hash.expiry_key(@test_key)
			assert_present expiry_key
			assert_not_equal @test_key, expiry_key
		end

		def test_remove
			assert_blank @hash.get('test')
			@hash.set('test', '1')
			assert_equal '1', @hash.get('test')
			@hash.remove('test')
			assert_blank @hash.get('test')
		end

		def test_all
			assert_blank @hash.get('test')
			@hash.set('test', '1')
			assert_equal '1', @hash.get('test')
			@hash.setex('test2', '1', 1)
			@hash.setex('test3', '2', 1)
			@hash.setex('test4', '2', 100)

			sleep 1.1
			all = @hash.all
			assert_equal 2, all.size
			assert_equal '1', @hash.get('test')
			assert_equal '2', @hash.get('test4')
			assert_blank @hash.get('test2')
			assert_blank @hash.get('test3')
		end
	end
end