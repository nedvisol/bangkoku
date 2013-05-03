require 'test/unit'
require './lib/cache/cachemanager.rb'
require 'securerandom'

class CacheManagerTest < Test::Unit::TestCase
  def test_get_miss
    cm = Cache::CacheManager.new('Dalli::Client', 'localhost:11211')
    key = SecureRandom.uuid
    value = cm.get(key) { |key|
      "data for #{key}"
    }
    
    assert_equal("data for #{key}",value)
    
    value = cm.get(key) { "foo" }
      
    assert_equal("data for #{key}",value)    
  end
end