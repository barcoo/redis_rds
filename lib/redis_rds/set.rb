module RedisRds
	class Set < RedisRds::Object
		include Enumerable

		def add(item)
			return connection.sadd(@redis_key, item)
		end
		alias_method :<<, :add
		alias_method :push, :add

		def remove(item)
			return connection.srem(@redis_key, item)
		end

		def all
			return ::Set.new(connection.smembers(@redis_key)).to_a
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
