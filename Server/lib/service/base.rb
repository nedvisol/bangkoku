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
      hash_data = model_to_hash(model_object)
      id = @data_access.put_row(@table_name, hash_data, @model_type)
      model_object.set_id!(id)
      return model_object
    end

    def retrieve(id, model_class)
      # do not retrieve if the ID starts with a wrong prefix

      model = $cache[:model].get(id) {
        hash_data = @data_access.get_row(@table_name, id)
        return nil if hash_data == nil
        raise 'Invalid Model type' if hash_data['model_type'] != @model_type
        obj = Object::const_get(model_class).new        
        obj.read_from_hash(hash_data)        
        $cache[:model].set(id, obj)
        obj
      }
      return model
    end

    # Update model
    # @TODO: need to figure out how to update hash value (will not delete old keys if updated)
    def update(model_object)
      hash_data = model_to_hash(model_object)
      id = @data_access.update_row(@table_name, model_object.id, hash_data)
      
      #clear cache
      $cache[:model].delete(model_object.id)
    end
    
    private 
    def model_to_hash(model_object)
      hash_data = {}
      model_object.attribute_map.each{ |instance_prop, attribute_key|
        value = model_object.instance_variable_get(instance_prop)
        if value != nil
          if !(value.kind_of?(Hash))
            hash_data[attribute_key] = value
          else
            value.each{ |k,v|
              hash_data["#{attribute_key}.#{k}"] = v
            }
          end
        end        
      }
      hash_data
    end

  end
end
