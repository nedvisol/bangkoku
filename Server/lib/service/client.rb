module Service
  class Client
    TABLE_NAME = 'entity'
    MODEL_TYPE = 'C'
    def initialize
      @table_name = TABLE_NAME
      @model_type = MODEL_TYPE
      super
    end

    # Create a new client in data store
    #
    # @param [Model::Client] Segment data to create
    def create(client)
      super(client)
    end

    def retrieve(client_id)
      # get from cache
      super(client_id, 'Model::Client')
    end    
    
    def update(client_id, attributes)
      @data_access.update_row(TABLE_NAME, client_id, attributes)

      # invalidate cache
      $cache[:entity].delete(client_id, nil)
    end
    

  end
end
