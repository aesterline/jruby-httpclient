require 'helper'

class ServerHeadersTest < Test::Unit::TestCase
  def test_response_contains_server_headers
    get = HTTP::Get.new("/set_header")
    response = @client.execute(get)

    assert_equal("FooBar", response.headers["Test-Header"])
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end

  def teardown
    @client.shutdown
  end
end