module Camcorder
  
  class Recording
    
    attr_reader :value
    attr_reader :behavior
    
    def initialize(&block)
      @value = nil
      @behavior = nil
    end
    
    def record(&block)
      res = yield
      # Make sure we store a copy of the result so future destructive mutations
      # do not change this value
      @value = deep_clone(res)
      @behavior = :return
      res
    rescue Exception => e
      @value = e
      @behavior = :raise
      raise e
    end
    
    def replay
      case @behavior
      when :return
        return @value
      when :raise
        raise @value
      end
    end
    
    def deep_clone(value)
      Marshal.load(Marshal.dump(value))
    end
    
    def ==(other)
      Marshal.dump(self) == Marshal.dump(other)
    end
    
  end
  
end
