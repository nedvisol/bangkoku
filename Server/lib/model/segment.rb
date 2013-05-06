module Model
  class Segment < Model::Base
    
    attr_accessor :segment_name, :auth_profile
    
    @@service = Service::Segment.new
    
    #ATTRIBUTE_KEYS = {:@segment_name => :segment_name, :@auth_profile => :auth_profile}
    @@properties = [:@segment_name, :@auth_profile]
    @@attribute_map = self.create_attribute_map(@@properties)
    
    def initialize(segment_name = nil, auth_profile = nil)
      super(@@properties, @@attribute_map, 'SG')
      @segment_name = segment_name
      @auth_profile = auth_profile  
      @service = @@service    
    end
    
    # Add new segment to data store
    def create
      super()
    end
    
    # Retrieve Segment record from data store
    def self.retrieve(segment_id)      
      @@service.retrieve(segment_id)      
    end
  end
end
