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
      value = @backend.get(key)
      if value == nil
        value = yield(key)
        @backend.set(key, value)
      end
      return value
    end
    
    def set(key, value)
      @backend.set(key, value)
    end
    
    
  end
end
