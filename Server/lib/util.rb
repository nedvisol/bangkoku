require 'json'

module Util
  UTIL_LARGE_NUM = 1 << 63 
  def Util.get_uuid(prefix)
    return "#{prefix}-#{SecureRandom.random_number(UTIL_LARGE_NUM).to_s(32)}"
  end
  
  def Util.restful_json_wrapper
    error = nil
    success = true
    result = nil
    begin
      result = yield
    rescue => e
      puts e   
      error = e 
      success = false
    end

    ret = {
      'success' => success ? 'true' : 'false',
      'result' => result
    }
    
    if error != nil
      ret['error'] = error
    end
    
    code = success ? 200: 500
    
    return code, ret.to_json
  end
  
end