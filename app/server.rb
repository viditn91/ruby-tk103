require 'socket'
require 'active_record'
require_relative 'models/position'
require_relative 'models/gps_update'

ActiveRecord::Base.logger = Logger.new("log/development.log")
ActiveRecord::Base.logger.level = 0

configuration = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

HANDSHAKE = "BP05"
UPDATE    = "BR00"

def store_location(message, device)
  update = GPSUpdate.new(message, device)
  puts "You are at: #{update.position}"
  update.position.save!
end

def parse(message)
  begin
    head    = message[0]
    serial  = message[1..12]
    command = message[13..16]
    body    = message[17..-2]
    tail    = message[-1]

    # puts <<-eos
    #   head    #{head}
    #   serial  #{serial}
    #   command #{command}
    #   body    #{body}
    #   tail    #{tail}
    # eos

    case command
    when HANDSHAKE
      puts "[HANDSHAKE] from #{serial}"
      store_location(body[15, -1], serial)
      { serial: serial }
    when UPDATE
      puts "[UPDATE] from #{serial}"
      store_location(body, serial)
    else
      puts "[LEAK] from #{serial}. Command -> #{command} can not be understood"
    end
  rescue Exception => e
    puts "[ERROR] #{e}."
    puts e.backtrace
  end
end

puts "GPS server listening on port 12345"
server = TCPServer.open 12345

loop do
  Thread.start(server.accept) do |client|
    puts "A client connected"

    message = ""
    loop do
      byte = client.recv(1)
      message += byte

      if byte == ")"
        returned_value = parse(message)
        
        if returned_value.is_a? Hash
          puts "[Response] Handshake response to #{returned_value[:serial]}"
          client.puts "(#{returned_value[:serial]}AP05)"
        end

        message = ""
      end
    end

    client.close
  end
end