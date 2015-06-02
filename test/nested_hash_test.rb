require 'test_helper'

module RedisRds
	class NestedHashTest < ActiveSupport::TestCase

		def setup
			super
			RedisSingleton.clear_test_db
		end

		def test_set
			h = RedisRds::NestedHash.new('test')
			h.set('k1', 'k2', 'k3', 'value')
			assert_equal 'value', h.get('k1', 'k2', 'k3')
		end

		def test_incr_decr
			h = RedisRds::NestedHash.new('test')
			assert_equal 1, h.incr('k1', 'k2', 'k3')
			assert_equal 2, h.incr('k1', 'k2', 'k3')
			assert_equal 1, h.decr('k1', 'k2', 'k3')
			assert_equal 5, h.incrby('k1', 'k2', 'k3', 4)
			assert_equal '5', h.get('k1', 'k2', 'k3')
		end
	end
end