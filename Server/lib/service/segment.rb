module Service
  class Segment
    
    TABLE_NAME = 'entity'
    
    def initialize
      @data_access = DataAccess::AWS::SimpleDB.new
    end
    
    def add_segment(name, auth_profile)
      attributes = {
        :name => name,
        :auth_profile => auth_profile
      }
      @data_access.put_row(TABLE_NAME, attributes, 'SG')
    end
    
    def retrieve_segment(segment_id)
      # get from cache
      data = $cache[:entity].get(segment_id) {
        hashData = @data_access.get_row(TABLE_NAME, segment_id)
        if hashData == nil
           nil
        else 
          { :name => hashData['name'], :auth_profile => hashData['auth_profile']}          
        end
      }      
      return data      
    end
    
  end
end
