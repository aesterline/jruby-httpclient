# jruby-httpclient

jruby-httpclient is a thin wrapper around Apache's HttpClient (version 4.1).   I found that Net::HTTP was
not threadsafe in JRuby.    This project is an attempt to make a threadsafe HTTP client for JRuby.

[![Build Status](https://secure.travis-ci.org/aesterline/jruby-httpclient.png)](http://travis-ci.org/aesterline/jruby-httpclient)

## Usage

```ruby
client = HTTP::Client.new(:default_host => "http://localhost:8080")
client.get("/src", :param => "value")
client.post("/create", :param => "value")
```

## Contributing to jruby-httpclient
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Adam Esterline. See LICENSE.txt for
further details.

