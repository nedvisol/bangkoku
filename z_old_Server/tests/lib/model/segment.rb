require 'test/unit'
require 'aws-sdk'
require 'require_all'

require_all 'lib'

class Segment < Test::Unit::TestCase
  def setup
    $cache = {
      :model => Cache::CacheManager.new('Dalli::Client', 'localhost:11211')
    }
  end
  
  def test_create
    segment = Model::Segment.new('test segment', 'test auth profile')
    segment.create
    
    assert_not_equal(nil, segment.id)
    assert_equal('test segment', segment.segment_name)
    assert_equal('test auth profile', segment.auth_profile)
  end
  
  def test_retrieve
    segment = Model::Segment.new('test segment', 'test auth profile')
    segment.create
    
    segment_r = Model::Segment.retrieve(segment.id)
    assert_not_equal(nil, segment_r.id)
    assert_equal('test segment', segment_r.segment_name)
    assert_equal('test auth profile', segment_r.auth_profile)

    # again with cache
    segment_r = Model::Segment.retrieve(segment.id)
    assert_not_equal(nil, segment_r.id)
    assert_equal('test segment', segment_r.segment_name)
    assert_equal('test auth profile', segment_r.auth_profile)
        
  end
  
end