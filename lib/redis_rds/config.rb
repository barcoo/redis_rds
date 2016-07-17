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

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML.load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, 'YAML configuration file contains invalid syntax. Using defaults.'); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end
