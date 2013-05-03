require 'test/unit'
require 'require_all'
require 'dalli'
require_all 'lib'

$cache = {
  :entity => Cache::CacheManager.new('Dalli::Client', 'localhost:11211')
}


class SecurityTest < Test::Unit::TestCase
  def test_register_client
    seg = Model::Segment.new
    sec = Model::Security.new(seg)
    
    sec.register_client('SG-71f7n525th2m',nil)
  end
end