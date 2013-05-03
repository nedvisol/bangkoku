require 'securerandom'

module DataAccess
  module AWS
    class SimpleDB
      def initialize
        @simpledb = ::AWS::SimpleDB.new
      end
            
      # Create a new row in SimpleDB. A new uuid is generated automatically unless provided.
      # Uses Conditional Put to prevent a duplicate ID generate (will throw an exception if occurs)
      # 
      # @param [String] table Domain name
      # @param [Hash] attributes Initial attributes to be added
      # @param [String] id Optional.
      
      def put_row (table, attributes, id_prefix = '', id = nil)
        item_name = (id==nil)? Util.get_uuid(id_prefix) : id
        ts = "%10.8f" % Time.now.to_f
        attributes['id'] = item_name
        attributes['timestamp'] = ts
        @simpledb.domains[table].items[item_name].attributes.put(
          :add => attributes,
          :unless => 'id' #only add unless "ID" exists
        )
        return item_name
      end
      
      
      # Retrieve data from SimpleDB
      #
      # @param [String] table Domain name
      # @param [String] key
      # @return Hash data of the row (will return all attributes)
      def get_row(table, key)
        hash = @simpledb.domains[table].items[key].attributes.to_h        
        if hash['id'] == nil # ID Must be there
          return nil
        end
        # flatten values
        hash.each{ |key,value|
          if value.kind_of?(Array)
            hash[key] = value[0]
          end
        }
        hash
      end  
      
    end
  end
end
