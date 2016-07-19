require 'test_helper'

module RedisRds
  class StringTest < ActiveSupport::TestCase
    def setup
      super
      @test_key = 'test'
      @string = RedisRds::String.new(@test_key)
    end

    def test_get
      assert_blank @string.get
      @string.set('test')
      assert_equal 'test', @string.get
    end

    def test_set
      assert_blank @string.get
      @string.set('test')
      assert_equal 'test', @string.get
    end

    def test_setex
      assert_blank @string.get
      @string.setex('test', 10)
      assert_equal 'test', @string.get
      assert @string.ttl > 0 && @string.ttl <= 10
    end

    def test_append
      assert_blank @string.get
      @string.set('test')
      assert_equal 'test', @string.get
      @string.append('hola')
      assert_equal 'testhola', @string.get
    end

    def test_incr
      assert_blank @string.get
      assert_equal 1, @string.incr
      assert_equal 2, @string.incr
      assert_equal '2', @string.get
    end

    def test_incrby
      assert_blank @string.get
      assert_equal 1, @string.incrby(1)
      assert_equal 6, @string.incrby(5)
      assert_equal '6', @string.get
    end

    def test_strlen
      assert_blank @string.get
      @string.set('test')
      assert_equal 'test'.length, @string.length
    end

    def test_setnx
      assert_blank @string.get
      @string.set('test')
      assert_equal 'test', @string.get
      @string.setnx('hola')
      assert_equal 'test', @string.get
    end

    def test_decr
      assert_blank @string.get
      @string.incrby(5)
      assert_equal 4, @string.decr
      assert_equal 3, @string.decr
      assert_equal '3', @string.get
    end

    def test_decrby
      assert_blank @string.get
      @string.incrby(5)
      assert_equal 4, @string.decrby(1)
      assert_equal 1, @string.decrby(3)
      assert_equal '1', @string.get
    end
  end
end
