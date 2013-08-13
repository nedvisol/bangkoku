module Service
  class Segment < Service::Base
    
    TABLE_NAME = 'entity'
    MODEL_TYPE = 'SG'

    def initialize
      @table_name = TABLE_NAME
      @model_type = MODEL_TYPE
      super
    end
    
    # Create a new segment in data store
    #
    # @param [Model::Segment] Segment data to create
    def create(segment)      
      super(segment)
    end
    
    def retrieve(segment_id)
      # get from cache
      super(segment_id, 'Model::Segment')     
    end
    
  end
end
