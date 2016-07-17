require 'test_helper'

module RedisRds
  class HashTest < ActiveSupport::TestCase
    def setup
      super
      RedisSingleton.clear_test_db
      @test_key = 'test'
      @hash = RedisRds::Hash.new(@test_key)
    end

    def test_get_set
      assert_blank @hash.get(:test)
      @hash.set(:test, '1')
      assert_equal '1', @hash.get(:test)
    end

    def test_get_setnx
      assert_blank @hash.get(:test)
      @hash.setnx(:test, '1')
      assert_equal '1', @hash.get(:test)
      @hash.setnx(:test, '2')
      assert_equal '1', @hash.get(:test)
    end

    def test_remove
      @hash.set(:test, '1')
      assert_equal '1', @hash.get(:test)
      @hash.remove(:test)
      assert_blank @hash.get(:test)
    end

    def test_incrby
      assert_equal 1, @hash.incrby(:test, 1)
      assert_equal 4, @hash.incrby(:test, 3)
      assert_equal 10, @hash.incrby(:test, 6)
    end

    def test_incr
      assert_equal 1, @hash.incr(:test)
      assert_equal 2, @hash.incr(:test)
      assert_equal 3, @hash.incr(:test)
    end

    def test_decr
      @hash.incrby(:test, 5)
      assert_equal 4, @hash.decr(:test)
      assert_equal 3, @hash.decr(:test)
      assert_equal 2, @hash.decr(:test)
    end

    def test_decrby
      @hash.incrby(:test, 6)
      assert_equal 5, @hash.decrby(:test, 1)
      assert_equal 3, @hash.decrby(:test, 2)
      assert_equal 0, @hash.decrby(:test, 3)
    end

    def test_all
      hash = { a: '1', b: '2', c: '3' }
      hash.each do |key, value|
        @hash.set(key, value)
      end

      values = @hash.all
      assert_equal hash[:a], values[:a]
      assert_equal hash[:b], values[:b]
      assert_equal hash[:c], values[:c]
    end

    def test_values
      hash = { a: '1', b: '2', c: '3' }
      hash.each do |key, value|
        @hash.set(key, value)
      end

      assert_equal hash.values, @hash.values
    end

    def test_keys
      hash = { a: '1', b: '2', c: '3' }
      hash.each do |key, value|
        @hash.set(key, value)
      end

      assert_equal hash.stringify_keys.keys, @hash.keys
    end

    def test_to_json
      hash = { a: '1', b: '2', c: '3' }
      hash.each do |key, value|
        @hash.set(key, value)
      end

      assert_equal hash.to_json, @hash.to_json
    end

    def test_each
      hash = { a: '1', b: '2', c: '3' }
      hash.each do |key, value|
        @hash.set(key, value)
      end

      @hash.each do |key, value|
        assert_equal hash[key.to_sym], value
      end
    end
  end
end
