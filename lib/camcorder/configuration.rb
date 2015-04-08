module Camcorder

  class Configuration

    attr_accessor :recordings_dir
    attr_accessor :verify_recordings

    def initialize
      @recordings_dir = ''
      @verify_recordings = true
    end

  end

end
