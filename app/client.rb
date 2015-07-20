require 'socket'

HOSTNAME = "localhost"
PORT = 12345

def mock_client
  socket = TCPSocket.new HOSTNAME, PORT

  puts "GPS client mock starting up..."
  puts "Sending Handshake"
  socket.write "(027043145986BP00000027043145986HSO)"
  puts "Handshake sent"
  sleep 1

  puts "Sending messages"
  sent_messages = 0
  longitude = 5207.4772

  loop do
    print "."
    socket.write "(027043145986BR00150630A#{longitude.to_s}N00505.9965E000.5214734138.2600000000L00000000)"
    longitude = (longitude + rand).round(4)
    sleep 5
  end

  puts "Closing connection"
  socket.close
end

mock_client
