module RedisRds
  class Hash < RedisRds::Object
    include Enumerable

    def get(key)
      return connection.hget(@redis_key, key)
    end
    alias_method :[], :get

    def set(key, value)
      return connection.hset(@redis_key, key, value)
    end
    alias_method :[]=, :set

    def mset(*args)
      return connection.hmset(@redis_key, *args)
    end

    def mget(*args)
      return connection.hmget(@redis_key,*arg)
    end

    def setnx(key, value)
      return connection.hsetnx(@redis_key, key, value)
    end

    def remove(key)
      return connection.hdel(@redis_key, key)
    end

    def incrby(key, increment)
      return connection.hincrby(@redis_key, key, increment)
    end

    def key?(key)
      return connection.hexists(@redis_key, key)
    end

    def incr(key)
      return incrby(key, 1)
    end

    def decr(key)
      return incrby(key, -1)
    end

    def decrby(key, decrement)
      return incrby(key, -decrement)
    end

    def all
      return (getall || {}).with_indifferent_access
    end

    def getall
      return connection.hgetall(@redis_key)
    end

    def values
      return all.values
    end

    def keys
      return all.keys
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
