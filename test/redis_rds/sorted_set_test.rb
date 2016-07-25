require 'test_helper'

module RedisRds
  class SortedSetTest < ActiveSupport::TestCase
    def setup
      super
      @test_key = 'test'
      @set = RedisRds::SortedSet.new(@test_key)
    end

    def test_push
      @set.push('a')
      @set.push('b')
      assert_equal %w(a b), @set.all
    end

    def test_add
      @set.add(2, 'b')
      @set.add(1, 'a')
      assert_equal %w(a b), @set.all
    end

    def test_remove_by_score
      @set.add(5, 'e')
      @set.add(4, 'd')
      @set.add(3, 'c')
      @set.add(2, 'b')
      @set.add(1, 'a')
      assert_equal 5, @set.size
      assert_equal 3, @set.remove_by_score(2, 4)
      assert_equal %w(a e), @set.all
    end

    def test_range
      @set.add(1, '1')
      @set.add(2, '2')
      @set.add(3, '3')

      asc = @set.range(0, 2)
      desc = @set.range(0, 2, order: :desc)

      assert_equal %w(1 2 3), asc
      assert_equal %w(3 2 1), desc
    end

    def empty
      assert @set.empty?
    end

    def test_include
      @set.add(1, '1')

      assert @set.include?(1)
      assert_not @set.include?(2)
    end

    def test_remove
      @set.add(1, '1')
      assert @set.include?(1)

      @set.remove(1)
      assert_not @set.include?(1)
      assert @set.empty?
    end
  end
end
