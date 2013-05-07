module Service
  class Base
    
    @table_name = nil
    @model_type = nil
    @@data_access = DataAccess::AWS::SimpleDB.new
    
    def initialize
        @data_access = @@data_access
    end
    
    # Create a row in data store using info from model object
    #
    # @param [Model::Base] Model base to create
    def create(model_object)
      hash_data = {}
      model_object.attribute_map.each{ |instance_prop, attribute_key|
        hash_data[attribute_key] = model_object.instance_variable_get(instance_prop)        
      }
      id = @data_access.put_row(@table_name, hash_data, @model_type)      
      model_object.set_id!(id)
      return model_object
    end
    
    def retrieve(id, model_class)
      # do not retrieve if the ID starts with a wrong prefix      

      model = $cache[:model].get(id) {
        hash_data = @data_access.get_row(@table_name, id)          
        raise 'Invalid Model type' if hash_data['model_type'] != @model_type    
        obj = Object::const_get(model_class).new
        obj.read_from_hash(hash_data)
        $cache[:model].set(id, obj)
        obj        
      }
      
      return model
    end
    
  end
end
