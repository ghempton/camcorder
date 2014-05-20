module Camcorder
  
  class Error < StandardError; end
  
  class RecordingError < Error
    attr_reader :key
    def initialize(key)
      @key = key
    end
    def message
      "Recording for key #{key} has changed"
    end
  end
  
  class ProxyRecordingError < Error
    attr_reader :klass, :name, :args, :side_effects
    def initialize(klass, name, args, side_effects)
      @klass = klass
      @name = name
      @args = args
      @side_effects = side_effects
    end
    def message
      "Recording for #{klass}.#{name} with args: #{args} and side_effects=#{side_effects} has changed. Consider using using `methods_with_side_effects`."
    end
  end
  
  class PlaybackError < Error
    attr_reader :key
    def initialize(key)
      @key = key
    end
    def message
      "Cannot find key '#{key}' for playback"
    end
  end
  
  class ProxyPlaybackError < Error
    attr_reader :klass, :name, :args, :side_effects
    def initialize(klass, name, args, side_effects)
      @klass = klass
      @name = name
      @args = args
      @side_effects = side_effects
    end
    def message
      "Cannot find recording for #{klass}.#{name} with args: #{args} and side_effects=#{side_effects}"
    end
  end
  
end
