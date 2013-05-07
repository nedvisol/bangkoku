module Model
  module Base
    attr_reader :id, :timestamp
    
    # Initialize with attribute keys map
    #
    # @param [Array] Array of data store attributes to be populated into instance
    def initialize

    end
    
    # Read data from hash and input into 
    def read_from_hash(hash_data, attribute_map)
      attribute_map.each{|instance_prop, attribute_key|
        instance_variable_set(instance_prop, hash_data[attribute_key])
      }
    end
    
    def set_id!(id)
      @id = id
    end
    
    def create(service)
      service.create(self)
    end

    
    def Base.create_attribute_map(properties)
      map = {}
      properties.each{|instance_prop|
        attribute_key  = instance_prop.to_s
        attribute_key[0] = ''
        map[instance_prop] = attribute_key
      }
      map
    end
    
    def Base.create_properties(properties)
      properties << :@id
      properties << :@timestamp
      properties
    end
        
  end
end
