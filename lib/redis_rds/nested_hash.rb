module RedisRds
  class NestedHash < RedisRds::Hash
    SEPARATOR = ':'

    def setnx(*keys, value)
      return super(format_key(keys), value)
    end

    def incrby(*keys, increment)
      return super(format_key(keys), increment)
    end

    def key?(key)
      return super(format_key(keys))
    end

    def get(*keys)
      super(format_key(keys))
    end

    def set(*keys, value)
      super(format_key(keys), value)
    end

    def setex(*keys, value, expiry)
      super(format_key(keys), value, expiry)
    end

    def remove(*keys)
      super(format_key(keys))
    end

    def format_key(keys)
      return Array.wrap(keys).join(SEPARATOR)
    end
    private :format_key
  end
end
