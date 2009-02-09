module GPSSpeed
  class UTM
    # http://www.koders.com/cpp/fid56D52408FAC344874E65BF9A1C54F3731C96A39B.aspx
    attr_reader :lat, :lon, :northing, :easting, :xzone, :yzone

    Fe = 500000.0
    Ok = 0.9996

    ZoneChars = "CDEFGHJKLMNPQRSTUVWX"

    def initialize lat, lon
      @lat, @lon = lat, lon
      lat_lon_to_utm_wgs84
    end 

    def lat_lon_to_utm_wgs84
      lat_lon_to_utm 6378137.0, 1 / 298.257223563
    end

    def lat_lon_to_utm(a, f)
      if (@lon <= 0.0)
        @xzone = 30 + (@lon / 6.0).to_i
      else
        @xzone = 31 + (@lon / 6.0).to_i
      end

      if (@lat < 84.0 && @lat >= 72.0)
        # Special case: zone X is 12 degrees from north to south, not 8.
        @yzone = ZoneChars[19]
      else
        @yzone = ZoneChars[((@lat + 80.0) / 8.0).to_i]
      end

      if (@lat >= 84.0 || @lat < -80.0)
        # Invalid coordinate; the vertical zone is set to the invalid
        # character.
        @yzone = '*'
      end

      latRad = @lat * Math::PI / 180.0
      lonRad = @lon * Math::PI / 180.0
      recf = 1.0 / f
      b = a * (recf - 1.0) / recf
      eSquared = calc_e_squared(a, b)
      e2Squared = calc_e2_squared(a, b)
      tn = (a - b) / (a + b);
      ap = a * (1.0 - tn + 5.0 * ((tn * tn) - (tn * tn * tn)) / 4.0 + 81.0 *
        ((tn * tn * tn * tn) - (tn * tn * tn * tn * tn)) / 64.0)
      bp = 3.0 * a * (tn - (tn * tn) + 7.0 * ((tn * tn * tn) - 
        (tn * tn * tn * tn)) / 8.0 + 55.0 * (tn * tn * tn * tn * tn) / 64.0) / 2.0
      cp = 15.0 * a * ((tn * tn) - (tn * tn * tn) + 3.0 * ((tn * tn * tn * tn) -
        (tn * tn * tn * tn * tn)) / 4.0) / 16.0
      dp = 35.0 * a * ((tn * tn * tn) - (tn * tn * tn * tn) + 11.0 *
        (tn * tn * tn * tn * tn) / 16.0) / 48.0
      ep = 315.0 * a * ((tn * tn * tn * tn) - (tn * tn * tn * tn * tn)) / 512.0
      olam = (@xzone * 6 - 183) * Math::PI / 180.0
      dlam = lonRad - olam
      s = Math.sin latRad
      c = Math.cos latRad
      t = s / c;
      eta = e2Squared * (c * c);
      sn = sphsn a, eSquared, latRad
      tmd = sphtmd ap, bp, cp, dp, ep, latRad
      t1 = tmd * Ok
      t2 = sn * s * c * Ok / 2.0
      t3 = sn * s * (c * c * c) * Ok * (5.0 - (t * t) + 9.0 * eta + 4.0 *
        (eta * eta)) / 24.0

      if (latRad < 0.0) 
        nfn = 10000000.0
      else 
        nfn = 0
      end

      @northing = nfn + t1 + (dlam * dlam) * t2 + (dlam * dlam * dlam *
        dlam) * t3 + (dlam * dlam * dlam * dlam * dlam * dlam) + 0.5
      t6 = sn * c * Ok
      t7 = sn * (c * c * c) * (1.0 - (t * t) + eta) / 6.0
      @easting = Fe + dlam * t6 + (dlam * dlam * dlam) * t7 + 0.5
      @northing = [@northing, 9999999.0].min
  end

    def calc_e_squared(a, b)
      ((a * a) - (b * b)) / (a * a)
    end

    def calc_e2_squared(a, b)
      ((a * a) - (b * b)) / (b * b)
    end


    def denom(es, sphi)
      Math.sqrt(1 - es - Math.sin(sphi) ** 3)
    end

    def sphsr(a, es, sphi)
      a * (1.0 - es) / denom(es, sphi) ** 3
    end

    def sphsn(a, es, sphi)
      a / Math.sqrt(1.0 - es * Math.sin(sphi) ** 2)
    end

    def sphtmd(ap, bp, cp, dp, ep, sphi)
      (ap * sphi) - (bp * Math.sin(2.0 * sphi)) + (cp * Math.sin(4.0 * sphi)) -
          (dp * Math.sin(6.0 * sphi)) + (ep * Math.sin(8.0 * sphi))
    end
  end
end
