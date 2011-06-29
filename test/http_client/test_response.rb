require 'helper'

class ResponseTest < Test::Unit::TestCase

  def test_response_body
    get = HTTP::Get.new("/echo", :content => "baz")
    response = @client.execute(get)
    assert_equal("baz", response.body)
  end

  def test_response_code
    get = HTTP::Get.new("/echo", :content => "baz")
    response = @client.execute(get)
    assert_equal(HTTP::Status::OK, response.status_code)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end

  def teardown
    @client.shutdown
  end
end