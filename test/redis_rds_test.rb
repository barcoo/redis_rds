require 'test_helper'

class RedisRdsTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::RedisRds::VERSION
  end
end
