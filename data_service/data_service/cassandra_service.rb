require 'cql'

##########3
#  create table objects (rowid uuid primary key, data map<text,blob>);

class CassandraService
  def initialize(host, keyspace)
    @host = host
    @keyspace = keyspace
  end

  # Insert or update a new row
  #
  # @param [String] name Table name
  # @param [String] id Row ID
  # @param [Hash] data Hash map of key-values
  def put_row(name, id, data)
    columns = []
    values = []
    data['rowid'] = id
    data.each{ |k,v|
      columns << k
      values << v
    }
    cql = cql_put_row(name, id, columns)
    
    client = get_client(@host, @keyspace)
    
    stmt = client.prepare(cql)
    stmt.execute(*values, :one)
  end

  def get_client(host, keyspace)
    client = Cql::Client.connect(host: host)
    client.use(keyspace)
    return client
  end

  def cql_put_row(name, id, columns)
    columns_joined = columns.join(',')
    placeholders = (['?'] * columns.count).join(',')
    cql = "insert into #{name} (#{columns_joined}) values (#{placeholders})"
    return cql
  end

end