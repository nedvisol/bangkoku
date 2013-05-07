require 'test/unit'
require 'aws-sdk'
require 'require_all'

require_all 'lib'

class Client < Test::Unit::TestCase
  def setup
    $cache = {
      :entity => Cache::CacheManager.new('Dalli::Client', 'localhost:11211')
    }
  end

  def test_create_fail_no_segment
    assert_raise ::RuntimeError do
      client = Model::Client.new('foo')
    end
  end

  def test_create
    segment = Model::Segment.create('foo', 'bar')

    client, passkey = Model::Client.create(segment.id)

    assert_not_equal(nil, client)
    assert_not_equal(nil, client.id)
    assert_not_equal(nil, client.hashed_passkey)
    assert_not_equal('', client.hashed_passkey)
    assert_not_equal(passkey, client.hashed_passkey)
  end

  def test_retrieve
    segment = Model::Segment.create('foo', 'bar')

    client, passkey = Model::Client.create(segment.id)
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
    segment = Model::Segment.create('foo', 'bar')
    client, passkey = Model::Client.create(segment.id)

    ret = Model::Client.validate_passkey(client.id, passkey)
    assert_equal(true, ret)
    ret = Model::Client.validate_passkey(client.id, 'foo')
    assert_equal(false, ret)        
  end
  

end