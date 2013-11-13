require 'rubygems'
require 'eventmachine'
require 'digest'

class RSConnector < EM::Connection
  
  # Constructor
  #   inits connector to its default values
  #
  def initialize
    @isAuthenticating = false
  end

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

      send_message "auth_ag ext_user none none"
    elsif (input[0] == 'rep')
      case input[1]
      when '002'
        authenticationHandler input
      else
        puts "unknown command : #{rep}"
      end
    end
  end
  
  # authenticationHandler :
  #   handles NetSoul authentication phase
  #
  
  def authenticationHandler rep
    if @isAuthenticating == false
      puts "authenticating"
      @isAuthenticating = true
      send_message "ext_user_log #{RSConfig.instance.login} #{replyHash} #{RSConfig.instance.location} RubySoul"
    else
      puts 'user successfully authenticated'
      @isAuthenticating = false
    end
  end
  
  # send_message :
  #   a wrapper for EventMachines' send_data method
  #   logs the message to be sent on the console, then
  #   sends it.
  #
  def send_message message
    message = "#{message}\n"
    puts "client << #{message}"
    send_data message
  end
  
  # replyHash :
  #   creates an hash compliying with NetSoul authentication
  #   methods
  #
  def replyHash
    puts "#{@hash}-#{@clientIP}/#{@clientPort}#{RSConfig.instance.location}"
    Digest::MD5.hexdigest "#{@hash}-#{@clientIP}/#{@clientPort}#{RSConfig.instance.password}"
  end
end