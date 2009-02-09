require 'rexml/document'
require 'ostruct'
require 'gpsspeed/utm_convert'

class Float
  def each
  end
end

module GPSSpeed
  class Runner
    def initialize(argv)
      filename, = argv
      @opt = {}
      @opt[:length] = 500 # Minimum required distance 
      read_gpx filename
      calc_utm
      list_distance_speeds
      filter_distance_speeds
      print_results
    end

    def read_gpx filename
      throw RuntimeError.new("Please specify file name") unless filename
      doc = nil
      File.open filename do |f|
        doc = REXML::Document.new f
      end

      @points = []
      REXML::XPath.each doc, '//trkpt' do |trkpt|
        lat = trkpt.attributes['lat']
        lon = trkpt.attributes['lon']
        date_time = DateTime.strptime trkpt.get_elements('time').first.text
        pp = OpenStruct.new
        pp.lat = lat.to_f
        pp.lon = lon.to_f
        pp.date_time = date_time
        @points << pp
      end
      puts "Read #{@points.size} track points"
    end


    def calc_utm
      @points.each do |p|
        p.utm = UTM.new p.lat, p.lon
      end
    end

    def list_distance_speeds
      @dist_speed_list = []
      (0..(@points.size - 2)).each do |i|
        ((i + 1)..(@points.size - 1)).each do |j|
          dist = distance @points[i], @points[j]
          next if dist < @opt[:length]
          ds = OpenStruct.new
          ds.distance = dist
          ds.begin = i
          ds.end = j
          ds.dt = (@points[j].date_time - @points[i].date_time) * 60.0 * 60.0
          ds.speed_ms = dist / ds.dt
          @dist_speed_list << ds
          break
        end
      end
    end

    def distance(a, b)
      Math.sqrt((a.utm.northing - b.utm.northing) ** 2 + 
                (a.utm.easting - b.utm.easting) ** 2)
    end

    def filter_distance_speeds
      @dist_speed_list.sort! {|a, b| a.speed_ms <=> b.speed_ms }.reverse!
      @dist_speed_list.reject! do |candidate|
        intersects_previous candidate
        false
      end
    end

    def intersects_previous candidate
      result = []
      @dist_speed_list[0...@dist_speed_list.index(candidate)].each do |prev|
        used = prev.begin..prev.end
        result ||= (prev.begin..prev.end).to_a & (candidate.begin..candidate.end).to_a
        break if result
      end
      result.any?
    end

    def print_results
      @dist_speed_list[1..10].each do |ds|
        puts '%6.4f    %i    %i' % [ds.speed_ms, ds.begin, ds.end]
      end
    end
  end
end
