require 'test_helper'

module RedisRds
  class ListTest < ActiveSupport::TestCase

    def setup
      super
      RedisSingleton.clear_test_db
      @test_key = 'test'
      @list = RedisRds::List.new(@test_key)
    end

    def test_size
      members = ['a', 'b', 'c', 'd', 'a']
      members.each { |m| @list.rpush(m) }

      assert_equal members.size, @list.size
    end

    def test_empty
      assert @list.empty?
      @list.rpush("one")
      assert !@list.empty?
    end

    def test_get
      assert_equal [], @list.get(0) # get all
      members = ['a', 'b', 'c', 'd', 'a']
      @list.rpush(members)

      assert_equal ['b', 'c'], @list.get(1, 2)
      assert_equal members.size, @list.size
    end

    def test_rpush
      members = ['a', 'b', 'c', 'd', 'a']
      @list.rpush(members)

      assert_equal members, @list.get(0)
      @list.rpush('z')
      assert_equal ['z'], @list.get(-1, -1)
    end

    def test_lpop
      assert_equal [], @list.get(0) # get all
      members = ['a', 'b', 'c', 'd', 'a']
      @list.rpush(members)
      assert_equal ['a'], @list.lpop
      assert_equal members[1..-1], @list.get(0)

      assert_equal ['b', 'c'], @list.lpop(2)
      assert_equal members[3..-1], @list.get(0)
    end

    def test_lpop_force
      assert_equal [], @list.get(0) # get all
      members = ['a', 'b', 'c', 'd', 'a']
      @list.rpush(members)
      assert_equal [], @list.lpop(members.size + 1, true)
      assert_equal members.size, @list.size

      assert_equal members, @list.lpop(members.size, true)
      assert @list.empty?
    end
  end
end