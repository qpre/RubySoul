require 'singleton'

class RSConfig
  include Singleton
  
  attr_accessor :host, :port, :login, :password
  
  def initialize
    loadConfig
  end
  
  def loadConfig
    config = YAML.load_file('config.yml')
    
    # server related options
    @host = config['default']['host']
    @port = config['default']['port']
    
    # user related options
    @login    = config['default']['login']
    @password = config['default']['password']
  end
  
end