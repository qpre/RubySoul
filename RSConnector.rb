require 'rubygems'
require 'eventmachine'

class RSConnector < EM::Connection

  # receive_data :
  #
  #   handles server incomming messages
  #   and delivers it to grandCentral for
  #   dispatch
  #
  def receive_data data
    if data.strip =~ /exit$/i
      EventMachine.stop
    else
      grandCentral data
    end
  end
  
  
  # grandCentral :
  #
  #   Handles servers commands and dispatches
  #   it to the rightful handler
  #
  def grandCentral data
    puts "server says : "
    puts data.chop
  end
end