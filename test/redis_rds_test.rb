require 'test_helper'

class RedisRdsTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, RedisRds
    RedisRds::Object.configure({connection: nil, namespace: 'test_namespace'})
    assert_equal 'test_namespace', RedisRds.namespace
  end
end
