module Model
  class Base
    attr_reader :id, :timestamp, :attribute_map, :properties, :prefix
    
    # Initialize with attribute keys map
    #
    # @param [Array] Array of data store attributes to be populated into instance
    def initialize(properties, attribute_map, prefix)
      @prefix = prefix  
      @properties = properties
      @properties << :@id
      @properties << :@timestamp
      @attribute_map = attribute_map
      @attribute_map[:@id] = 'id'
      @attribute_map[:@timestamp] = 'timestamp'    
    end
    
    # Read data from hash and input into 
    def read_from_hash(hash_data)
      if hash_data['id'].start_with?(@prefix) == false
        raise 'Invalid prefix'
      end      
      
      @attribute_map.each{|instance_prop, attribute_key|
        instance_variable_set(instance_prop, hash_data[attribute_key])
      }
    end
    
    def set_id!(id)
      @id = id
    end
    
    def create
      @service.create(self)
    end
    
    def self.create_attribute_map(properties)
      map = {}
      properties.each{|instance_prop|
        attribute_key  = instance_prop.to_s
        attribute_key[0] = ''
        map[instance_prop] = attribute_key
      }
      map
    end
    
    
    def marshal_dump
      array = []
      @properties.each{|prop|
        array << instance_variable_get(prop)
      }
      array
    end
    
    def marshal_load array      
      @properties.each_index{|idx|
        instance_variable_set(@properties[idx], array[idx])
      }                
    end
  end
end
