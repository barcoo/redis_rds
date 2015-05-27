module RedisRds
  class SortedStringSet < RedisRds::SortedSet
    DEFAULT_SCORE = 0

    def add(item)
      super(DEFAULT_SCORE, item)
    end

    def push(item)
      return add(item)
    end

    def all
      return range('-', '+').to_a
    end

    def remove(item)
      return connection.zrem(@redis_key, item)
    end

    def range(min, max)
      min, max = [min, max].map do |r|
        next(r) if ['-', '+'].include?(r) || r.start_with?('[') || r.start_with?('(')
        "[#{r}"
      end

      return connection.zrangebylex(@redis_key, min, max)
    end
  end
end
