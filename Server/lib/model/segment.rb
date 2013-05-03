module Model
  class Segment
    
    def initialize
      @service = Service::Segment.new
    end
    
    def create_segment(name, auth_profile)
      # TODO: validate segment creation rules here
      @service.add_segment(name, auth_profile)
    end
    
    def retrieve_segment(segment_id)      
      @service.retrieve_segment(segment_id)
    end
  end
end
