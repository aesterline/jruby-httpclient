require 'helper'

class TestClientCreation < Test::Unit::TestCase
  def test_can_be_created_with_options
    client = HTTP::Client.new(:host => "localhost", :port => 8080)
    result = client.get("/echo", :content => "hi")

    assert_equal("hi", result)
  end

  def test_can_be_created_with_base_url
    client = HTTP::Client.new("http://localhost:8080")
    result = client.get("/echo", :content => "hi there")

    assert_equal("hi there", result)
  end

  def test_can_be_created_with_base_url_and_options
    client = HTTP::Client.new("http://localhost", :port => 8080)
    result = client.get("/echo", :content => "me too")

    assert_equal("me too", result)
  end

  def test_can_create_with_url_that_has_path
    client = HTTP::Client.new("http://localhost/echo", :port => 8080)
    result = client.get("/", :content => "me three")

    assert_equal("me three", result)
  end
end