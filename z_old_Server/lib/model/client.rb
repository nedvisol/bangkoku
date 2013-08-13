require 'securerandom'
require 'digest/sha2'

module Model
  class Client

    include Model::Base

    attr_accessor :segment_id, :name, :location, :profile_data
    attr_reader :geohash, :hashed_passkey

    @@service = Service::Client.new
    @@properties = Base.create_properties([:@segment_id, :@hashed_passkey, :@name, :@geohash, :@location, :@profile_data])
    @@attribute_map = Base.create_attribute_map(@@properties)

    def initialize(segment_id = nil, name = nil, location = nil, profile_data = nil)
      @segment_id = segment_id
      @name = name
      @location = location
      @profile_data = profile_data
    end

    # Retrieve Client record from data store
    def self.retrieve(client_id)
      @@service.retrieve(client_id)
    end

    def attribute_map
      @@attribute_map
    end

    def read_from_hash(hash_data)
      super(hash_data, @@attribute_map)
    end

    # Register client and retrieve Client Secret Passkey
    # Based on auth profile of the segment, userid/password may or may not be required (i.e. account creation)
    # If success, returns generated passkey and instance properties updated
    # @note Only hashed passkey is stored
    def create
      segment = Model::Segment.retrieve(@segment_id)

      if segment == nil
        #uh-oh not good
        raise 'Invalid Segment ID'
      end

      # @TODO: check segment stuff...

      #for now assume we don't need to validate user/pass, go ahead and create passkey
      passkey = SecureRandom.base64(30)
      @hashed_passkey = Model::Client.digest_passkey(passkey)

      #store into database
      super(@@service)      

      return passkey
    end   

    # Update properties
    def update
      super(@@service)
    end

    # Validate if the provided client_id and passkey matched
    #
    # @returns [Boolean] true if matched, false otherwise
    def self.validate_passkey(client_id, passkey)
      client = Model::Client.retrieve(client_id)      
      return (client.hashed_passkey == Model::Client.digest_passkey(passkey))
    end

    def self.digest_passkey(passkey)
      obj = Digest::SHA2.new << passkey
      obj.to_s
    end
    

  end
end
