#
# Setup the camcorder before every test
#
RSpec.configure do |config|

  recording_name_for = lambda do |metadata|
    description = if metadata[:description].empty?
                    # we have an "it { is_expected.to be something }" block
                    metadata[:scoped_id]
                  else
                    metadata[:description]
                  end
    example_group = if metadata.key?(:example_group)
                      metadata[:example_group]
                    else
                      metadata[:parent_example_group]
                    end

    if example_group
      [recording_name_for[example_group], description].join('/')
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
