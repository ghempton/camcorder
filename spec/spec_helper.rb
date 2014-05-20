require 'json'
require 'rspec'

require 'camcorder'
require 'camcorder/rspec'

require 'support/test_object'
require 'support/test_object2'
require 'byebug'

Camcorder.config.recordings_dir = 'spec/recordings'
