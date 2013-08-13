module Model
  class Segment
    
    include Model::Base
    
    attr_accessor :segment_name, :auth_profile
    
    @@service = Service::Segment.new        
    @@properties = Base.create_properties([:@segment_name, :@auth_profile])
    @@attribute_map = Base.create_attribute_map(@@properties)
    
    def initialize(segment_name = nil, auth_profile = nil)      
      @segment_name = segment_name
      @auth_profile = auth_profile                
    end
    
    # Add new segment to data store
    def create
      super(@@service)
    end
    
    # Retrieve Segment record from data store
    def self.retrieve(segment_id)      
      @@service.retrieve(segment_id)      
    end
    
    
    def attribute_map
      @@attribute_map
    end
    
    def read_from_hash(hash_data)
      super(hash_data, @@attribute_map)
    end
    
  end
end
