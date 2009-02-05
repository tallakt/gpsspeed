require 'rexml/document'
require 'ostruct'
require 'gpsspeed/utm_convert'

module GPSSpeed
  class Runner
    def initialize
      filename, = ARGV
      @opt = {}
      @opt[:length] = 50 # Minimum required distance 
      read_gpx filename
      calc_utm
      list_distance_speeds
      filter_distance_speeds
    end

    def read_gps filename
      doc = nil
      File.open filename do |f|
        doc = REXML::Document.new f
      end

      @points = []
      doc.each '**/trkpt' do |trkpt|
        lat = trkpt.attributes['lat']
        lon = trkpt.attributes['lon']
        date_time = DateTime.new trkpt.get_elements('time').first.text
        pp = OpenStruct.new
        pp.lat = lat
        pp.lon = lon
        pp.date_time = date_time
        @points << pp
      end
      puts 'Read #{@points.size} track points'
    end


    def calc_utm
      pp.each do |p|
        p.utm = UTM.new p.lat, p.lon
      end
    end

    def list_distance_speeds
      @dsl = []
      (0..(pp.size - 2)).each do |i|
        ((i + 1)..(pp.size -1)).each do |j|
          dist = distance pp[i], pp[j]
          next if dist < @opt[:length]
          ds = OpenStruct.new
          ds.distance = dist
          ds.begin = i
          ds.end = j
          ds.dt = (pp[j].date_time - pp[i].date_time) * 60.0 * 60.0
          ds.speed_ms = dist / dt
          dsl << ds
          break
        end
      end
    end

    def distance(a, b)
      Math.sqrt((a.utm.northing - b.utm.northing) ** 2 + 
                (a.utm.easting - b.utm.easting) ** 2)
    end

    def filter_distance_speeds
      dsl.sort! {|a, b| a.speed_ms <=> b.speed_ms }
      dsl.reject do |candidate|
        intersects_previous candidate
      end
    end

    def intersects_previous candidate
      result = false
      dsl[0...dsl.index(candidate)].each do |prev|
        used = prev.begin..prev.end
        result ||= (prev.begin..prev.end).to_a & (candiate.begin..candidate.end).to_a
        break if result
      end
      result
    end
  end
end
