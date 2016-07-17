require 'test_helper'

module RedisRds
  class SetTest < ActiveSupport::TestCase
    def setup
      super
      RedisSingleton.clear_test_db
      @test_key = 'test'
      @set = RedisRds::Set.new(@test_key)
    end

    def test_add_include?
      @set.add('testing')
      assert @set.include?('testing')
    end

    def test_remove
      @set.add('testing')
      assert @set.include?('testing')
      @set.remove('testing')
      assert !@set.include?('testing')
    end

    def test_all
      members = %w(a b c d a)
      members.each { |m| @set.add(m) }

      all = @set.all
      assert_equal ::Set.new(members), ::Set.new(all)
    end

    def test_size
      members = %w(a b c d a)
      members.each { |m| @set.add(m) }

      assert_equal ::Set.new(members).size, @set.size
    end

    def test_merge
      members = %w(a b c d a)
      @set.merge(members)
      assert_equal ::Set.new(members), ::Set.new(@set.all)
    end

    def test_consume
      members = %w(a b c d a)
      assert_equal 4, @set.merge(members)
      assert_equal ::Set.new(members).size, @set.size

      consumed = @set.consume
      assert_equal 0, @set.size
      assert_equal ::Set.new(consumed), ::Set.new(members)
      assert_blank @set.all
    end

    def test_to_json
      members = %w(a b c d a)
      members.each { |m| @set.add(m) }

      assert_equal ::Set.new(members).to_a.sort.to_json, JSON.parse(@set.to_json).sort.to_json
    end
  end
end
