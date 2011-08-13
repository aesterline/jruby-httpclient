require 'helper'

class ServerHeadersTest < Test::Unit::TestCase
  def test_response_contains_server_headers
    get = HTTP::Get.new("/set_header")
    response = @client.execute(get)

    assert_equal("FooBar", response.headers["Test-Header"])
  end
  
  def test_response_headers_to_hash
    get = HTTP::Get.new("/set_header")
    response = @client.execute(get)
    response_hash = response.headers.to_hash
    assert_equal(response_hash["Test-Header"], "FooBar")
    assert_equal(response_hash["Content-Length"], "0")
  end
  
  def test_response_headers_iteration
    get = HTTP::Get.new("/set_header")
    response = @client.execute(get)
    
    headers = values = []
    response.headers.each do |header, value|
      headers << header; values << value
    end
    
    assert headers.include? "Test-Header"
    assert headers.include? "Content-Length"
    assert values.include? "FooBar"
    assert values.include? "0"
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end

  def teardown
    @client.shutdown
  end
end