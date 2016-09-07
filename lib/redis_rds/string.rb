module RedisRds
  class String < RedisRds::Object
    def get
      return connection.get(@redis_key)
    end

    # Lifted from npepine/restruct
    # @param [Object] value The object to store; note, it will be stored using a string representation
    # @param [Integer] expiry The expiry time in seconds; if nil, will never expire
    # @param [Boolean] nx Not Exists: if true, will not set the key if it already existed
    # @param [Boolean] xx Already Exists: if true, will set the key only if it already existed
    # @return [Boolean] True if set, false otherwise
    def set(value, expiry: nil, nx: nil, xx: nil)
      options = {}
      options[:ex] = expiry.to_i unless expiry.nil?
      options[:nx] = nx unless nx.nil?
      options[:xx] = xx unless xx.nil?

      connection.set(@redis_key, value, options)
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
