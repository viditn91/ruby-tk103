class GPSUpdate
  def initialize(message)
    puts "message #{message}"
    @time         = message[0..5]
    @availability = message[6]
    @latitude     = message[7..16]
    @longitude    = message[17..27]
    @speed        = message[28..32]
    @time         = message[33..38]
    @orientation  = message[39..44]
    @io_state     = message[45..52]
    @milepost     = message[53]
    @mile_data    = message[54..61]
  end

  def position
    @position ||= Position.from_decimal(@latitude, @longitude)
  end
end
