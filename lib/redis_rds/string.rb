module RedisRds
  class String < RedisRds::Object
    def get
      return connection.get(@redis_key)
    end

    def set(value)
      return connection.set(@redis_key, value)
    end

    def setex(value, expiry)
      return connection.setex(@redis_key, expiry, value)
    end

    def append(suffix)
      return connection.append(@redis_key, suffix)
    end

    def incr
      return connection.incr(@redis_key)
    end

    def incrby(increment)
      return connection.incrby(@redis_key, increment)
    end

    def length
      return connection.strlen(@redis_key)
    end

    def setnx(value)
      return connection.setnx(@redis_key, value)
    end

    def decr
      return connection.decr(@redis_key)
    end

    def decrby(decrement)
      return connection.decrby(@redis_key, decrement)
    end
  end
end
