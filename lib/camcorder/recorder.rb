require 'yaml'
require 'camcorder/recording'

module Camcorder

  class Recorder

    attr_reader :recordings
    attr_reader :filename

    def initialize(filename, verify_recordings: Camcorder.config.verify_recordings)
      @filename = filename
      @recordings = {}
      @changed = false
      @verify_recordings = verify_recordings
    end

    def transaction(&block)
      start
      yield
    ensure
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
          recordings[key].replay
        else
          raise PlaybackError.new(key)
        end
      else
        begin
          recording = Recording.new
          result = recording.record(&block)
        ensure
          @changed = true
          if recordings.has_key?(key)
            unless verify_recordings(recordings[key], recording)
              raise RecordingError.new(key)
            end
          else
            recordings[key] = recording
          end
          result
        end
      end
    end

    def verify_recordings(a, b)
      if @verify_recordings.is_a?(Proc)
        @verify_recordings.call(a, b)
      elsif @verify_recordings
        a == b
      else
        true
      end
    end

  end

end
