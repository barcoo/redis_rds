module RedisRds
  class ExpirableHash < RedisRds::Hash
    EXPIRY_KEY_SUFFIX = '__expiry__'.freeze

    def get(key)
      result = nil
      value, expires_at = connection.hmget(@redis_key, key, expiry_key(key))
      if expired?(expires_at)
        remove(key)
      else
        result = value
      end

      return result
    end

    def set(key, value)
      connection.multi do |redis|
        redis.hset(@redis_key, key, value)
        redis.hdel(@redis_key, expiry_key(key))
      end
    end

    def setex(key, value, expiry)
      expires_at = Time.now.to_i + expiry
      connection.hmset(@redis_key, key, value, expiry_key(key), expires_at)
    end

    def expiry_key(key)
      return "#{key}#{EXPIRY_KEY_SUFFIX}"
    end

    def remove(key)
      connection.multi do |redis|
        redis.hdel(@redis_key, key)
        redis.hdel(@redis_key, expiry_key(key))
      end
    end

    def all
      hash = ::Hash[super().group_by do |key, _value|
        if key.ends_with?(EXPIRY_KEY_SUFFIX)
          key[0...(key.length - EXPIRY_KEY_SUFFIX.length)]
        else
          key
        end
      end.map { |key, values| [key, values.map(&:second)] }]

      expired, valid = hash.partition { |_key, values| expired?(values.second) }
      expired.each { |key, _| remove(key) }

      return ::Hash[valid.map { |key, values| [key, values.first] }]
    end

    def expired?(expires_at)
      return false if expires_at.nil?
      return Time.now.to_i >= expires_at.to_i
    end
    private :expired?
  end
end
