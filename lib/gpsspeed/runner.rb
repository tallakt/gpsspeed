require 'rexml/document'
require 'ostruct'
require 'geoutm'
require 'enumerator'
require 'optparse'

class FloatA # necessary dt rexml bug
  def each
  end
end

module GPSSpeed
  class Runner
    DEFAULT_LENGTH = 500
    DEFAULT_SPEED_FMT = 'm/s'
    DEFAULT_LENGTH_FMT = 'm'

    LengthUnits = {
      'm' => 1.0,
      'ft' => 3.2808399,
      'km' => 0.001,
      'miles' => 0.000621371192,
      'nm' => 0.000539956803
    }

    SpeedUnits = {
      'm/s' => 1.0,
      'knots' => 1.9438612860586,
      'km/h' => 3.6,
      'mph' => 2.23693629
    }

    def initialize(argv)
      # Command line options
      @opt = {}
      parse_options argv
      @opt[:length] ||= DEFAULT_LENGTH # Minimum required distance 
      @opt[:speed_fmt] ||= DEFAULT_SPEED_FMT
      @opt[:length_fmt] ||= DEFAULT_LENGTH_FMT

      filename, = argv

      read_gpx filename
      list_distance_speeds
      filter_distance_speeds
      print_results
    end

    def parse_length(l)
      LengthUnits.each do |name, factor|
        m = l.match /^(\d+(.\d+)?)\s?#{name}$/i
        return m[1].to_f * factor if m
      end
      m = l.match /^(\d+(.\d+)?)$/i
      throw RuntimeError.new('Illegal length format: ' + l) unless m
      m[1].to_f
    end

    def parse_options(argv)
      OptionParser.new do |op|
        op.banner = "Usage: gpsspeed [options] <input.gpx>"
        op.on("-l", "--length DIST", "Minimum required length (default #{DEFAULT_LENGTH}m)",
                "  Accepts #{LengthUnits.keys.join ','}") do |l|
          @opt[:length] = parse_length l
        end
        op.on("-s", "--speed-format FMT", "Select speed format (default #{DEFAULT_SPEED_FMT})",
                "  Accepts #{SpeedUnits.keys.join ','}") do |fmt|
          @opt[:speed_fmt] = fmt
        end
        op.on("-f", "--length-format FMT", "Select length format (default #{DEFAULT_LENGTH_FMT})",
                "  Accepts #{LengthUnits.keys.join ','}") do |fmt|
          @opt[:length_fmt] = fmt
        end
        op.on_tail("-h", "--help", "Show this message") do
          puts op
          exit
        end
      end.parse! argv
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
        pp.latlon = GeoUtm::LatLon.new lat.to_f, lon.to_f
        pp.utm = pp.latlon.to_utm GeoUtm::Ellipsoid::lookup(:wgs84), @points.first && @points.first.utm.zone
        pp.date_time = date_time
        @points << pp
      end
      @points.sort! {|a, b| a.date_time <=> b.date_time }
      # puts "Read #{@points.size} track points"
    end

    def list_distance_speeds
      @dist_speed_list = []
      (0..(@points.size - 2)).each do |i|
        ((i + 1)..(@points.size - 1)).each do |j|
          dist = @points[i].utm.distance_to @points[j].utm
          next if dist < @opt[:length]
          ds = OpenStruct.new
          ds.distance = dist
          ds.begin = i
          ds.end = j
          ds.dt = (@points[j].date_time - @points[i].date_time) * 24.0 * 60.0 * 60.0
          ds.speed_ms = dist / ds.dt
          @dist_speed_list << ds
          break
        end
      end
    end

    def filter_distance_speeds
      @dist_speed_list.sort! {|a, b| a.speed_ms <=> b.speed_ms }.reverse!
      @dist_speed_list.reject! do |candidate|
        intersects_previous candidate
      end
    end

    def intersects_previous candidate
      intersects = nil
      @dist_speed_list[0...@dist_speed_list.index(candidate)].each do |prev|
        used = prev.begin..prev.end
        intersects ||= ((prev.begin..prev.end).to_a & (candidate.begin..candidate.end).to_a).any?
        break if intersects
      end
      intersects
    end

    def print_results
      puts '%20s%10s%10s%10s%20s%20s' % 
        ["Speed [#{@opt[:speed_fmt]}]", '#frm', '#to', '#n', 'time [s]', "Distance [#{@opt[:length_fmt]}]"]
      (@dist_speed_list[0..39] || []).each do |ds|
        puts "%20.4f%10i%10i%10i%20.2f#{length_printf_fmt(20)}" % [speed_conv(ds.speed_ms), ds.begin, 
          ds.end, ds.end - ds.begin + 1, ds.dt, length_conv(ds.distance)]
      end
    end

    def speed_conv(speed)
      speed * SpeedUnits[@opt[:speed_fmt]]
    end

    def length_conv(length)
      length * LengthUnits[@opt[:length_fmt]]
    end

    def length_printf_fmt(width)
      "%#{width}.#{-Math::log10(LengthUnits[@opt[:length_fmt]]).to_i + 1}f"
    end
  end
end
