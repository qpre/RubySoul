require 'rubygems'
require 'eventmachine'
require 'digest'

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
    puts "server >> #{data}"
    input = data.split(' ')
    if (input[0] == 'salut')
      
      @hash       = input[2]
      @clientIP   = input[3]
      @clientPort = input[4]
      
      message = "auth_ag ext_user none none\n"
      
      puts "client << #{message}"
      send_data message
    elsif (input[0] == 'rep')
      responseHandler input
    end
  end
  
  def responseHandler rep
    if (rep[1] == '002')
      puts "authenticating"
      message = "ext_user_log #{RSConfig.instance.login} #{replyHash} #{RSConfig.instance.location} RubySoul"
      puts message
      send_data(message)
    end
  end
  
  def replyHash
    Digest::MD5.hexdigest("#{@hash}-#{@clientIP}/#{@clientPort}#{RSConfig.instance.location}")
  end
end