class Position < ActiveRecord::Base
  SOUTH = "S"
  WEST  = "W"

  class << self
    # Init from Degrees Minutes notation
    # E.g. 5207.4772N 00505.9965E
    def from_decimal(lat, lon, device)
      @lat = "#{lat[0..1]}.#{minutes_to_degrees(lat[2..8].to_f)}".to_f
      @lat *= -1 if lat[9] == SOUTH
      @lat = @lat.round(7)

      @lon = "#{lon[0..2]}.#{minutes_to_degrees(lon[3..9].to_f)}".to_f
      @lon *= -1 if lon[10] == WEST
      @lon = @lon.round(7)

      Position.create(lat: @lat, lon: @lon, device: device)
    end

    def minutes_to_degrees(minutes)
      minutes = minutes * 100.0 / 60.0
      minutes_str = minutes.to_s.gsub(".", "")
      minutes < 10 ? "0#{minutes_str}" : "#{minutes_str}"
    end
  end

  def to_s
    "#{lat}, #{lon}"
  end
end
