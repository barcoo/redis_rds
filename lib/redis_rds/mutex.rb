module RedisRds
  class Mutex < RedisRds::String
    DEFAULT_EXPIRY = 60.seconds

    attr_reader :id, :expiry

    def initialize(id, expiry = DEFAULT_EXPIRY, owner = '')
      super("#{namespace}:mutex:#{id}")

      @id = id
      @expiry = expiry
      @owner = owner.blank? ? generate_owner : owner
    end

    def lock
      connection.set(@redis_key, @owner, ex: @expiry, nx: true)
      return locked?
    end

    def locked?
      return connection.get(@redis_key) == @owner
    end
    alias owned? locked?

    def release
      self.delete if owned?
    end

    def serialize
      [@id, @expiry, @owner]
    end

    def synchronize
      if self.lock
        begin
          yield if block_given?
        ensure
          self.release
        end
      end
    end

    def generate_owner
      now = Time.now.to_f
      random = Random.new(now)
      return Digest::MD5.hexdigest(random.rand(now).to_s)
    end
    private :generate_owner

    class << self
      def unserialize(serialized)
        return self.new(*serialized)
      end
    end
  end
end
