require 'test/unit'
require 'aws-sdk'
require 'require_all'

require_all 'lib'

class Client < Test::Unit::TestCase
  def setup
    $cache = {
      :model => Cache::CacheManager.new('Dalli::Client', 'localhost:11211')
    }
  end

  def test_create_fail_no_segment
    assert_raise ::RuntimeError do
      client = Model::Client.new('foo segment', 'foo name')
      client.create 
    end
  end

  def test_create
    segment = Model::Segment.new('foo', 'bar')
    segment.create

    client = Model::Client.new(segment.id, 'foo name')
    passkey = client.create

    assert_not_equal(nil, client)
    assert_not_equal(nil, client.id)
    assert_not_equal(nil, client.hashed_passkey)
    assert_not_equal('', client.hashed_passkey)
    assert_not_equal(passkey, client.hashed_passkey)
  end

  def test_retrieve
    segment = Model::Segment.new('foo', 'bar')
    segment.create

    client = Model::Client.new(segment.id, 'foo name')
    passkey = client.create
    assert_not_equal(nil, client)
    assert_not_equal(nil, client.id)
    assert_not_equal(nil, client.hashed_passkey)
    assert_not_equal('', client.hashed_passkey)
    assert_not_equal(passkey, client.hashed_passkey)

    client_r = Model::Client.retrieve(client.id)
    assert_equal(client.id,client_r.id)
    assert_equal(client.segment_id,client_r.segment_id)
    assert_equal(client.hashed_passkey,client_r.hashed_passkey)    
  end
  
  def test_validate_passkey
    segment = Model::Segment.new('foo', 'bar')
    segment.create
    client = Model::Client.new(segment.id, 'foo name')
    passkey = client.create

    ret = Model::Client.validate_passkey(client.id, passkey)
    assert_equal(true, ret)
    ret = Model::Client.validate_passkey(client.id, 'foo')
    assert_equal(false, ret)        
  end
  
  def test_update
    segment = Model::Segment.new('foo', 'bar')
    segment.create

    client = Model::Client.new(segment.id, 'foo name')
    passkey = client.create

    client_r = Model::Client.retrieve(client.id)
    assert_equal(client.id,client_r.id)
    assert_equal(client.name, client_r.name)
    
    #update
    client_r.name = 'bar name'
    client_r.profile_data = {'data1' => 'foo1', 'data2'=>'bar1'}
    client_r.update
    
    #test to make sure it persists
    client_q = Model::Client.retrieve(client.id)
    assert_equal(client.id,client_q.id)
    assert_equal('bar name', client_q.name)    
        
  end

end