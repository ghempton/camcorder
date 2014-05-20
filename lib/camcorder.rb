require "camcorder/version"
require 'camcorder/errors'
require 'camcorder/proxy'
require 'camcorder/recorder'
require 'camcorder/configuration'

#
# Provides similar functionality as the VCR gem but works on arbitrary objects.
# This is useful for things like Net::IMAP and Net::SMTP which cannot be
# captured by VCR.
#
module Camcorder
  
  def self.default_recorder
    @default_recorder
  end
  
  def self.default_recorder=(value)
    @default_recorder = value
  end
  
  def self.config
    @config ||= Configuration.new
  end
  
  #
  # Creates a proxy subclass for the particular class
  #
  def self.proxy_class(klass, recorder=nil, &block)
    Class.new(Proxy) do
      class << self
        attr_reader :klass
        attr_reader :recorder
      end
      @klass = klass
      @recorder = recorder
      def initialize(*args)
        recorder = self.class.recorder || Camcorder.default_recorder
        super(recorder, self.class.klass, *args)
      end
      self.class_eval &block if block
    end
  end
  
  #
  # Rewrites the `new` method on the passed in class to always return proxies.
  #
  def self.intercept_constructor(klass, recorder=nil, &block)
    proxy_class = self.proxy_class(klass, recorder) do
      def _initialize
        @instance ||= klass._new(*@init_args)
      end
      self.class_eval &block if block
    end
    
    klass.class_eval do
      @proxy_class = proxy_class
      class << self
        alias_method :_new, :new
        def new(*args)
          @proxy_class.new(*args)
        end
      end
    end
  end
  
  def self.deintercept_constructor(klass)
    klass.class_eval do
      class << self
        alias_method :new, :_new
        remove_method :_new
      end
    end
  end
  
end
