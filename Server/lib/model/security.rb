require 'securerandom'
module Model
  class Security
    
    TABLE_NAME = 'entity'
    
    def initialize(segmentModel)
      @segmentModel = segmentModel
      @data_access = DataAccess::AWS::SimpleDB.new
    end
    
    
    # Register client and retrieve Client Secret Passkey
    # Based on auth profile of the segment, userid/password may or may not be required (i.e. account creation)
    #
    # @param [String] segmentId
    # @param [String] clientId
    # @param [Hash] options - parameters for acount creation based on auth profile (:userid, :password, :email, etc)
    # @returns [String] Passkey
    def register_client(segment_id, options = nil)
      segment = @segmentModel.retrieve_segment(segment_id)
      
      if segment == nil
        #uh-oh not good
        raise 'Invalid Segment ID'
      end
      
      #for now assume we don't need to create an account, go ahead and create passkey
      passkey = SecureRandom.base64(30)
      
      attributes = {
        'segment_id' => segment_id,
        'passkey' => passkey         
      }
            
      #store into database
      client_id = @data_access.put_row(TABLE_NAME,attributes,'CL')
      
      {'clientId' => client_id, 'passkey' => passkey} 
    end
  end
end
