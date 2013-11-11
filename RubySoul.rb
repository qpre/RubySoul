require 'yaml'
require_relative 'RSConnector'
require_relative 'RSConfig'

# RubySoul:
#
# This class is aimed to handle a socket connection to 
# a NetSoul server.
#
# This is configured with EPITA's defaults, just change 
# your config.rb file if you want to use it from somewhere
# else
#

class RubySoul
  
  # Constructor :
  #
  #   Initialises RbSouls' parameters
  #
  def initialize
    puts 'Initializing context'
  end
  
  # start :
  #
  #   creates a EventMachine instance
  #
  def start
    EM.run do
      sigHandler
      EM.connect RSConfig.instance.host, RSConfig.instance.port, RSConnector
    end
  end
  
  # sigHandler
  #
  #   handles signals received
  #
  def sigHandler
    Signal.trap("INT")  { stop }
    Signal.trap("TERM") { stop }
  end
  
  # stop :
  #
  #   closes the client (it any connection was up)
  #
  def stop
    EM.stop
  end
  
  
  # Destructor :
  # 
  #   What about cleaning our mess ?
  #
  def finalize
    puts 'byebye'
    stop
  end
end

# Start me up !

ns = RubySoul.new
ns.start

