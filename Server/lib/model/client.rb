require 'securerandom'
require 'digest/sha2'

module Model
  class Client < Model::Base
    
    @@client_service = Service::Client.new
    @@cache_manager = $cache
    
    attr_accessor :segment_id, :hashed_passkey, :name, :location, :geohash, :profile_data
    
    attr_reader :geohash
    
    ATTRIBUTE_KEYS = [:segment_id, :hashed_passkey, :name, :location, :geohash]
        
    def initialize(hash_data = nil)
      super(ATTRIBUTE_KEYS, 'C')
    end
    
    
    # Register client and retrieve Client Secret Passkey
    # Based on auth profile of the segment, userid/password may or may not be required (i.e. account creation)
    # If success, returns generated passkey and instance properties updated
    # @note Only hashed passkey is stored
    
    
    def self.create(segment_id)
      segment = Model::Segment.retrieve_segment(segment_id)
      
      if segment == nil
        #uh-oh not good
        raise 'Invalid Segment ID'
      end
      
      # @TODO: check segment stuff...
      
      #for now assume we don't need to validate user/pass, go ahead and create passkey
      passkey = SecureRandom.base64(30)
      hashed_passkey = self.hash_passkey(passkey)
            
      #store into database
      client_id = @@client_service.add_client(segment_id, hashed_passkey)
      
      return Model::Client.new(client_id, segment_id, hashed_passkey), passkey          
    end
    
    def self.retrieve(client_id)
      hash_data = @@client_service.retrieve_client(client_id)
      if hash_data == nil
        return nil
      end      
      Model::Client.new()      
    end
    
    # Update properties         
    def update(client_id, location = nil, name = nil, profile_data = nil)
      client = Model::Client.retrieve(client_id)
    end

    # Validate if the provided client_id and passkey matched
    #
    # @returns [Boolean] true if matched, false otherwise
    def self.validate_passkey(client_id, passkey)
      client = Model::Client.retrieve(client_id)
      return (client.hashed_passkey() == self.hash_passkey(passkey))
    end
   
    private    
    def self.hash_passkey(passkey)
      obj = Digest::SHA2.new << passkey
      obj.to_s
    end    
    
    
  end
end
