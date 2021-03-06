require 'singleton'

class RSConfig
  include Singleton
  
  attr_accessor :host, :port, :login, :password, :location
  
  # Constructor :
  #   loads config
  #
  def initialize
    loadConfig
  end
  
  # loadConfig :
  #   loads config from config.yml
  #
  def loadConfig
    config = YAML.load_file('config.yml')
    
    # server related options
    @host = config['default']['host']
    @port = config['default']['port']
    
    # user related options
    @login    = config['default']['login']
    @password = config['default']['password']
    @location = config['default']['location']
  end
end