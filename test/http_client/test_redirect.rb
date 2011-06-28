require 'helper'

class RedirectTest < Test::Unit::TestCase
  def test_get_redirect
    result = @client.get("/redirect", :content => "foo")

    assert_equal("foo", result)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080", :handle_redirects => true)
  end

  def teardown
    @client.shutdown
  end
end