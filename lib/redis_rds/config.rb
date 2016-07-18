require 'yaml'
require 'redis'

module RedisRds
  # Configuration defaults
  @config = {
    host: 'localhost',
    db: 1,
    port: 6379,
    timeout: 30,
    thread_safe: true,
    # FIXME: add username and password
    namespace: 'testns',
    connection: nil
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k, v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }

    if opts[:connection].present?
      connection = opts[:connection]
    else
      config[:db] = config[:db].to_i
      connection = Redis.new(config)
    end

    RedisRds::Object.configure(connection: connection, namespace: opts[:namespace])
  end

  def self.config
    @config
  end
end
