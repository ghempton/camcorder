#
# Setup the camcorder before every test
#
RSpec.configure do |config|
  
  recording_name_for = lambda do |metadata|
    description = metadata[:description]

    if example_group = metadata[:example_group]
      [recording_name_for[example_group], description].reject{|d| !d || d == ''}.join('/')
    else
      description
    end
  end
  
  config.around(:each) do |example|
    name = recording_name_for[example.metadata].gsub(/[^\w\-\/]+/, '_')
    filename = File.join(Camcorder.config.recordings_dir, "#{name}.yml")
    Camcorder.default_recorder = Camcorder::Recorder.new(filename)
    Camcorder.default_recorder.transaction do
      example.run
    end
  end
end
