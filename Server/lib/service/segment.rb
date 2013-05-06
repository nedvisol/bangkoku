module Service
  class Segment < Service::Base
    
    TABLE_NAME = 'entity'
    PREFIX = 'SG'

    def initialize
      @table_name = TABLE_NAME
      @prefix = PREFIX
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
