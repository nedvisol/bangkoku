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

      def put_row (table, attributes, model_type = '', id = nil)
        item_name = (id==nil)? Util.get_uuid : id
        ts = "%10.8f" % Time.now.to_f
        attributes['id'] = item_name
        attributes['model_type'] = model_type
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
      def get_row(table, key, consistent_read = true)
        hash = nil
        if consistent_read
          ::AWS::SimpleDB.consistent_reads {
            hash = do_get_row(table, key)
          }
        else
          hash = do_get_row(table, key)
        end
        hash
      end

      # Update row in SimpleDB
      # 
      # @param [String] table Table name
      # @param [String] key Key of the row
      # @param [Hash] attributes Hashtable of the attributes to be updated {key => value, ...}
      # @param [Hash] options Hashtable for options. Use :if and :value to check and only update if value exists; 
      #                     use :unless to check and only update if an attribute does not exist 
      #                     {:if => <key name>, :value =>  <expected value> } 
      #                     {:unless => <key name> }
      def update_row(table, key, attributes, options = nil)
        options = (options == nil)? {} : options
        options[:replace] = attributes  
        @simpledb.domains[table].items[item_name].attributes.put(
        options        
        )        
      end

      private

      def do_get_row(table, key)
        hash = @simpledb.domains[table].items[key].attributes.to_h
        # flatten values
        hash.each{ |key,value|
          if value.kind_of?(Array) && value.count == 1
            # flatten if only 1 item
            hash[key] = value[0]
          end
        }
        if hash['id'] == nil # ID Must be there
          return nil
        end
        hash
      end

    end
  end
end
