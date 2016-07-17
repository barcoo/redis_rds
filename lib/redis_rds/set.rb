module RedisRds
  class Set < RedisRds::Object
    include Enumerable

    def add(item)
      return connection.sadd(@redis_key, item)
    end
    alias << add
    alias push add

    def merge(enumerable)
      lua_script = "
        local result = 0;
        for i, item in ipairs(ARGV) do
          result = result + redis.call('sadd', KEYS[1], item);
        end
        return result;"
      result = connection.eval(lua_script, [@redis_key], enumerable.entries)
      result = [] if result.blank?

      return result
    end

    def remove(item)
      return connection.srem(@redis_key, item)
    end

    def all
      return ::Set.new(connection.smembers(@redis_key)).to_a
    end

    def consume
      lua_script = "
        local result = redis.call('smembers', KEYS[1]);
        redis.call('del', KEYS[1]);
        return result;"
      result = connection.eval(lua_script, [@redis_key])
      result = [] if result.blank?

      return ::Set.new(Array.wrap(result).compact).to_a
    end

    def size
      return connection.scard(@redis_key)
    end

    def include?(object)
      return connection.sismember(@redis_key, object)
    end

    def to_json
      return all.to_json
    end

    # TODO: Implement lazy enumerator
    def each(&block)
      return all.each(&block)
    end
  end
end
