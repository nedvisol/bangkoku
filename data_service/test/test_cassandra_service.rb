require 'test/unit'
require './data_service/cassandra_service.rb'

# create table foo_table (rowid text primary key, col1 blob, col2 blob)

class CassandraServiceTest < Test::Unit::TestCase
  def test_cql_put_row
    cs = CassandraService.new('localhost', 'test')
    cql = cs.cql_put_row('foo_table', 'id-1234',['col1','col2'])
    assert_equal('insert into foo_table (col1,col2) values (?,?)',cql)      
  end  
  
  def test_put_row
    cs = CassandraService.new('localhost', 'test')
    cql = cs.put_row('foo_table', 'id-1234', {'col1'=>'value1', 'col2'=>'value2'})    
  end
  
end