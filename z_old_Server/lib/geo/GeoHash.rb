class GeoHash
  @@latErr = [45.0, 22.5, 11.25, 5.625, 2.8125, 1.40625, 0.703125, 0.3515625,
    0.17578125, 0.087890625, 0.0439453125, 0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125, 0.00137329101563,
    0.00068664550782, 0.00034332275391, 0.00017166137696, 0.00008583068848, 0.00004291534424, 0.00002145767212, 0.00001072883606, 0.00000536441803]
  @@lngErr = [90.0, 45.0, 22.5, 11.25, 5.625, 2.8125, 1.40625, 0.703125, 0.3515625,
    0.17578125, 0.087890625, 0.0439453125, 0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125, 0.00137329101563,
    0.00068664550782, 0.00034332275391, 0.00017166137696, 0.00008583068848, 0.00004291534424, 0.00002145767212, 0.00001072883606]

  @@bits = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512,
    1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576,
    2097152, 4194304, 8388608] #24 bits

  def GeoHash.to_hash(latitude, longtitude)
    hashNum = 0

    midLat = 0
    midLng = 0
    curLat = latitude
    curLng = longtitude
    (0..23).each{|idx|
      if curLat > midLat
        hashNum = hashNum + 1
        midLat = midLat + @@latErr[idx]
      else
        midLat = midLat - @@latErr[idx]
      end
      hashNum = hashNum << 1

      if curLng > midLng
        hashNum = hashNum + 1
        midLng = midLng + @@lngErr[idx]
      else
        midLng = midLng - @@lngErr[idx]
      end
      # puts "#{curLat} midLat #{midLat}, #{curLng} midLng #{midLng}, #{hashNum.to_s(2)}"
      hashNum = hashNum << 1
    }
    hashNum = hashNum >> 1

    return hashNum
  end

  def GeoHash.to_coord(hashNum)
    midLat = 0
    midLng = 0
    #24 bits - start with highest bit first
    bitVal = 140737488355328
    (0..23).each{ |idx|
      if (hashNum & bitVal) > 0
        midLat = midLat + @@latErr[idx]
      else
        midLat = midLat - @@latErr[idx]
      end

      bitVal = bitVal >> 1
      if (hashNum & bitVal) > 0
        midLng = midLng + @@lngErr[idx]
      else
        midLng = midLng - @@lngErr[idx]
      end
      bitVal = bitVal >> 1
      # puts "(#{midLat}, #{midLng}) - #{sss}, #{bitVal}"
    }
    return [midLat, midLng]
  end

end