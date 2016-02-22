require 'test_helper'

module RedisRds
  class SortedSetTest < ActiveSupport::TestCase

    def setup
      super
      RedisSingleton.clear_test_db
      @test_key = 'test'
      @set = RedisRds::SortedSet.new(@test_key)
    end

    def test_push
      @set.push('a')
      @set.push('b')
      assert_equal ['a', 'b'], @set.all
    end

    def test_add
      @set.add(2, 'b')
      @set.add(1, 'a')
      assert_equal ['a', 'b'], @set.all
    end

    def test_remove_by_score
      @set.add(5, 'e')
      @set.add(4, 'd')
      @set.add(3, 'c')
      @set.add(2, 'b')
      @set.add(1, 'a')
      assert_equal 5, @set.size
      assert_equal 3, @set.remove_by_score(2,4)
      assert_equal ['a', 'e'], @set.all
    end

    def test_range
      @set.add(1, '1')
      @set.add(2, '2')
      @set.add(3, '3')

      asc = @set.range(0, 2)
      desc = @set.range(0, 2, order: :desc)

      assert_equal ['1', '2', '3'], asc
      assert_equal ['3', '2', '1'], desc
    end
  end
end
