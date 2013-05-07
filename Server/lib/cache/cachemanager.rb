require 'dalli'

module Cache
  class CacheManager    
    def initialize(backend_class, options)
      @backend = Object::const_get(backend_class).new(options)
    end
    
    # Get item from cache and, if missed, execute the block to rebuild the item and re-populate the cache
    #
    # @param [String] key Cache key
    def get(key)
      cached_value = @backend.get(key)
      if cached_value == nil
        value = yield(key)
        @backend.set(key, serialize(value))
      else                
        value = deserialize(cached_value)
      end
      return value
    end
    
    def set(key, value)
      @backend.set(key, serialize(value))
    end
    
    private 
    def serialize(obj)    
      Marshal.dump(obj)      
    end
    def deserialize(bin)      
      Marshal.load(bin)
    end
    
  end
end
