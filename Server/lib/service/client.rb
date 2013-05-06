module Service
  class Client
    TABLE_NAME = 'entity'
    def initialize
      @data_access = DataAccess::AWS::SimpleDB.new
    end

    def add_client(segment_id, passkey, user_id = nil, password = nil, email = nil)
      attributes = {
        'segment_id' => segment_id,
        'passkey' => passkey
      }

      attributes['userId'] = user_id if user_id != nil
      attributes['password'] = password if password != nil
      attributes['email'] = email if email != nil

      client_id = @data_access.put_row(TABLE_NAME,attributes,'CL')
    end

    # Retrieve Client record from data store
    #
    # @param [String] client_id
    # @returns [Hash] client data (:segment_id, :passkey, :online_status, :
    def retrieve_client(client_id)
      # get from cache
      data = $cache[:entity].get(client_id) {
        hash_data = @data_access.get_row(TABLE_NAME, client_id)
        verify_entity_data(hash_data)
        if hash_data == nil
          data = nil
        else
          data = {
            :id => hash_data['id'], :segment_id => hash_data['segment_id'],
            :passkey => hash_data['passkey'], :user_id => hash_data['user_id'],
            :password => hash_data['password'], :email => hash_data['email']
          }
        end
        data
      }
      return data
    end
    
    def update(client_id, attributes)
      @data_access.update_row(TABLE_NAME, client_id, attributes)
      
      # invalidate cache
      $cache[:entity].delete(client_id, nil)
    end
    
    def verify_entity_data(hash_data)
      raise 'Missing ID attribute' if hash_data['id'] == nil
      raise 'Missing Timestamp' if hash_data['ts'] == nil
      raise 'Invalid prefix' if hash_data['id'].start_with?('CL') != true      
    end

  end
end
