require 'require_all'
require 'sinatra'
require 'aws-sdk'

require_all 'lib'

#initialize global stuff
segmentModel = Model::Segment.new
securityModel = Model::Security.new(segmentModel)
$cache = {
  :entity => Cache::CacheManager.new('Dalli::Client', 'localhost:11211')
}

#  Admin APIs

# /segment?name=<segment name>&authProfile=<auth profile>
put '/segment' do
  status_code, response  = Util.restful_json_wrapper do
    segmentModel.create_segment( params['name'], params['authProfile'])   
  end
  
  status status_code
  body response  
end

put '/segment/:segmentId/client' do
  status_code, response  = Util.restful_json_wrapper do
    securityModel.register_client(params['segmentId'],nil)    
  end
  status status_code
  body response  
end

