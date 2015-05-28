module RedisRds
	class Object
		attr_accessor :redis_key

		def initialize(redis_key)
			@redis_key = format_redis_key(redis_key)
		end

		@@namespace = nil
		@@connection = nil
    def self.configure(options)
    	@@namespace = options[:namespace]
      @@connection = options[:connection]
    end

		def self.connection
			return @@connection
		end

		def self.namespace
			return @@namespace
		end

		def delete
			return connection.del(@redis_key)
		end

		def type
			return connection.type(@redis_key)
		end

		def expire(expiry)
			return connection.expire(@redis_key, expiry)
		end

		def expireat(timestamp)
			return connection.expireat(@redis_key, timestamp.to_i)
		end

		def dump
			return connection.dump(@redis_key)
		end

		def exists?
			return connection.exists(@redis_key)
		end

		def persist
			return connection.persist(@redis_key)
		end

		def ttl
			return connection.ttl(@redis_key)
		end

		def pttl
			return connection.pttl(@redis_key)
		end

		def format_redis_key(key)
			key = "#{namespace}:#{key}" unless key.starts_with?(namespace)
			return key
		end
		private :format_redis_key
	end
end
