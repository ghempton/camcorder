require 'yaml'

module Camcorder
  
  class Recorder

    attr_reader :recordings
    attr_reader :filename

    def initialize(filename)
      @filename = filename
      @recordings = {}
      @changed = false
    end

    def transaction(&block)
      start
      yield
      commit
    end

    def start
      if File.exists?(filename)
        @recordings = YAML.load_file(filename)
        @replaying = true
      else
        @recordings = {}
        @replaying = false
      end
    end

    def commit
      return unless @changed
      FileUtils.mkdir_p File.dirname(filename)
      File.open(filename, 'w') {|f| YAML.dump(recordings, f) }
    end

    def record(key, &block)
      if @replaying
        if recordings.has_key?(key)
          recordings[key]
        else
          raise PlaybackError.new(key)
        end
      else
        result = yield
        @changed = true
        if recordings.has_key?(key)
          if !deep_equals(recordings[key], result)
            raise RecordingError(key)
          end
        else
          # Make sure we store a copy of the result so future destructive mutations
          # do not change this value
          recordings[key] = deep_clone(result)
        end
        result
      end
    end

    def deep_clone(value)
      YAML.load(YAML.dump(value))
    end
    
    def deep_equals(a, b)
      YAML.dump(a) == YAML.dump(b)
    end

  end

end
