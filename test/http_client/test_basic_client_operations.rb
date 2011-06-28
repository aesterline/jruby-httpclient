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

  def test_can_get_full_url
    result = @client.get("http://localhost:8080/echo", :content => "hello")

    assert_equal("hello", result)
  end

  def test_can_post_full_url
    result = @client.post("http://localhost:8080/echo", :content => "hello")

    assert_equal("hello", result)
  end

  def test_can_delete_full_url
    result = @client.delete("http://localhost:8080/echo")

    assert_equal("delete", result)
  end

  def test_can_put_full_url
    result = @client.put("http://localhost:8080/echo")

    assert_equal("put", result)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end
end