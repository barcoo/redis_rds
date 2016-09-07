module RedisRds
  class Counter < RedisRds::String
    # Disable warning since one cannot freeze multiline heredocs...
    # rubocop: disable Style/MutableConstant
    RING_INCREMENT_SCRIPT = <<~LUA
      local by = tonumber(ARGV[1])
      local max = tonumber(ARGV[2])
      local current = redis.call('get', KEYS[1])
      local value = current and tonumber(current) or 0

      value = (value + by) % max
      redis.call('set', KEYS[1], value)

      return value
    LUA

    def incrby(increment, max: nil)
      value = if max.nil?
        super(increment)
      else
        ring_increment_script(increment.to_i, max.to_i).to_i
      end

      return value
    end

    def ring_increment_script(increment, max)
      return connection.eval(RING_INCREMENT_SCRIPT, [@redis_key], [increment, max])
    end
    private :ring_increment_script
  end
end
