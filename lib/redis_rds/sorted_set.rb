module RedisRds
  class SortedSet < RedisRds::Object
    include Enumerable

    def add(score, item)
      return connection.zadd(@redis_key, score, item)
    end

    def push(item)
      index = size
      return add(index, item)
    end
    alias_method :<<, :push

    def all
      return connection.zrange(@redis_key, 0, -1).to_a
    end

    def size
      return connection.zcard(@redis_key)
    end

    def include?(item)
      return !index_of(item).nil?
    end

    def remove(item)
      return connection.zrem(@redis_key, item)
    end

    def range(min, max)
      return connection.zrange(@redis_key, min, max)
    end

    def index_of(item)
      return connection.zrank(@redis_key, item)
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
