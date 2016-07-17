module RedisRds
  class Composite
    extend Forwardable

    attr_reader :members
    def_delegators :@members, :[], :[]=, :assoc, :size, :empty?,
      :each, :include?, :length, :merge

    def initialize(key)
      @key = key
      @members = {}.with_indifferent_access
    end

    def add(key, klass)
      object = klass.new(format_member_key(key))
      @members[key] = object
    end

    def format_member_key(key)
      return "#{@key}:#{key}"
    end
    private :format_member_key

    def delete(key)
      if @members.key?(key)
        @members[key].delete
        @members.delete(key)
      end
    end

    def clear
      @members.each do |k, _|
        self.delete(k)
      end
      @members.clear
    end

    def method_missing(*args)
      result = nil

      key = args.first
      result = @members[key] if key.present?

      return result
    end
  end
end
