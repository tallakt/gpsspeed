require 'rexml/document'
require 'ostruct'
require 'geoutm'
require 'enumerator'

class FloatA # necessary dt rexml bug
  def each
  end
end

module GPSSpeed
  class Runner
    def initialize(argv)
      filename, = argv
      @opt = {}
      @opt[:length] = 100 # Minimum required distance 
      read_gpx filename
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
        pp.latlon = GeoUtm::LatLon.new lat.to_f, lon.to_f
        pp.utm = pp.latlon.to_utm GeoUtm::Ellipsoid::lookup(:wgs84), @points.first && @points.first.utm.zone
        pp.date_time = date_time
        @points << pp
      end
      puts "Read #{@points.size} track points"
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
      puts '%12s  %4s  %4s  %4s  %12s  %12s' % ['Speed [m/s]', '#frm', '#to', '#n', 'time [s]', 'Distance [m]']
      (@dist_speed_list[0..39] || []).each do |ds|
        puts '%12.4f  %4i  %4i  %4i  %12.2f  %12.1f' % [ds.speed_ms, ds.begin, ds.end, ds.end - ds.begin + 1, 
          ds.dt, ds.distance]
      end
    end
  end
end
