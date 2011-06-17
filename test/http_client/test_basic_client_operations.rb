require 'helper'

class TestBasicClientOperations < Test::Unit::TestCase
  def test_simple_get
    result = @client.get("/echo", :content => "hello")

    assert_equal("hello", result)
  end

  def test_simple_post
    result = @client.post("/echo", :content => "world")

    assert_equal("world", result)
  end

  def test_simple_delete
    result = @client.delete("/echo")

    assert_equal("delete", result)
  end

  def test_simple_put
    result = @client.put("/echo")

    assert_equal("put", result)
  end

  def test_timeout
    client = HTTP::Client.new(:host => "localhost", :port => 8080, :timeout_in_seconds => 2)

    assert_raises(Timeout::Error) do
      client.get("/slow", :sleep => "30")
    end
  end

  def setup
    @client = HTTP::Client.new(:host => "localhost", :port => 8080)
  end
end