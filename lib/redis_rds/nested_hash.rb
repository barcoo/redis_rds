module RedisRds
	class NestedHash < RedisRds::Hash
		SEPARATOR = ':'

		def get(*keys)
			super(format_key(keys))
		end

		def set(*keys, value)
			super(format_key(keys), value)
		end

		def incr(*keys)
			super(format_key(keys))
		end

		def decr(*keys)
			super(format_key(keys))
		end

		def incrby(*keys, increment)
			super(format_key(keys), increment)
		end

		def decrby(*keys, increment)
			super(format_key(keys), increment)
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
