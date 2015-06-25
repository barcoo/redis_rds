module RedisRds
  class List < RedisRds::Object
    include Enumerable

    def size
      return connection.llen(@redis_key)
    end

    def empty?
      return self.size == 0
    end

    def get(start, stop = -1)
      return connection.lrange(@redis_key, start, stop)
    end

    def rpush(elems)
      return connection.rpush(@redis_key, Array.wrap(elems))
    end

    def lpush(elems)
      return connection.lpush(@redis_key, Array.wrap(elems))
    end

    def lpop(length = 1, force=false)
      lua_script = %q(
        local length = tonumber(ARGV[1]);
        if (ARGV[2] ~= 'true' or redis.call('llen', KEYS[1])>=length) then
          local result = redis.call('lrange', KEYS[1], 0, length - 1);
          redis.call('ltrim', KEYS[1], length, - 1);
          return result
        else return ''
        end)
      result = connection.eval(lua_script, [@redis_key], [length, force])
      result = [] if result.blank?

      return result
    end

    def each(&block)
      return get(0).each(&block)
    end

    def clear
      # if start > end redis clears the list
      # http://redis.io/commands/ltrim
      return connection.ltrim(@redis_key, 1, 0)
    end
  end
end
