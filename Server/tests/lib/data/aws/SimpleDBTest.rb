require 'test/unit'
require './lib/util'
require './lib/data/aws/simpledb.rb'
require 'aws-sdk'

class SimpleDBTest < Test::Unit::TestCase
  def test_put_row
    sdb = DataAccess::AWS::SimpleDB.new
    id = sdb.put_row('test-domain',{'attr1' => 'v1', 'attr2'=> 'v2'},'TEST')
    puts id
  end
  
  def test_put_row_dup
    sdb = DataAccess::AWS::SimpleDB.new
    id = sdb.put_row('test-domain',{'attr1' => 'v1', 'attr2'=> 'v2'}, 'TEST')
    puts id
    assert_raise AWS::SimpleDB::Errors::ConditionalCheckFailed do
      id = sdb.put_row('test-domain',{'attr1' => 'v3', 'attr2'=> 'v3'}, nil, id)     
    end
    puts id      
  end
  
  def test_put_and_get
    sdb = DataAccess::AWS::SimpleDB.new
    id = sdb.put_row('test-domain',{'attr1' => 'foo'}, 'TEST')
      sleep 2 # eventual consistent
    value = sdb.get_row('test-domain', id)
    assert_equal(false, value == nil)    
    assert_equal('foo', value['attr1'])
  end
  
end