# Camcorder

Need to have VCR-like functionality for more than just http? Wait no more. This gem allows you to record arbitrary method invocations from arbitrary objects.

```ruby
require 'camcorder'

//Need recorder 

recorder = Camcorder::Recorder.new('recordings.json')

imap = Camcorder::Proxy.new(recorder, Net::IMAP, imap_host, imap_port, imap_ssl, nil, false)
imap.login(username, decrypted_password)
imap.search(query)
imap.disconnect
```

The above code will create an actual `Net::IMAP` object the first time around. Subsequent invocations will not, instead using recorded values.

For convenience, Camcorder provides a way to intercept the constructor for a class:

```ruby
require 'camcorder'

Camcorder.intercept_constructor(Net::IMAP)

imap = Net::IMAP.new(imap_host, imap_port, imap_ssl, nil, false)
imap.login(username, decrypted_password)
imap.search(query)
imap.disconnect
```

## Side Effects

By default, Camcorder matches up a method invocation to a recording based on the passed in arguments. Methods with side effects need to be explicitly noted:

```ruby
require 'camcorder'

Camcorder.intercept_constructor(Net::IMAP) do
  methods_with_side_effects :examine, :select
end

imap = Net::IMAP.new(imap_host, imap_port, imap_ssl, nil, false)
imap.login(username, decrypted_password)
imap.select('INBOX')
imap.search(query)
imap.select('Sent Items') # will cause the `search` call below to return a different value
imap.search(query)
imap.disconnect
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'camcorder'
```

And then execute:

    bundle

Or install it yourself as:

    gem install camcorder

## Usage with Rspec

In your `spec_helper.rb` file:

```ruby
require 'camcorder/rspec'

Camcorder.config.recordings_dir = 'spec/recordings'
```

## Contributing

1. Fork it ( http://github.com/ghempton/camcorder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
