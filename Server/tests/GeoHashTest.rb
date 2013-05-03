require 'test/unit'
require './lib/geo/GeoHash.rb'

class GeoHashTest < Test::Unit::TestCase
    def test_to_hash
      puts
      puts "hash = " + GeoHash.to_hash(42.583, 28.0).to_s(16)
    end
    
    def test_to_coord
      puts
      hashNum = "cba5d4ebaffe".to_i(16)
      coord = GeoHash.to_coord(hashNum)
      puts "coord (#{coord[0]}, #{coord[1]})"
    end
end