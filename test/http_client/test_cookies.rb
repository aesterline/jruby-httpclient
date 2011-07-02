require 'helper'

class CookieTest < Test::Unit::TestCase
  def test_cookies_can_be_remembered
    @client.get("/set_cookie", :cookie => "nom nom nom")
    result = @client.get("/echo_cookie")

    assert_equal("nom nom nom", result)
  end

  def test_cookie_can_be_retrieved_from_response
    get = HTTP::Get.new("/set_cookie", :cookie => "yum")
    response = @client.execute(get)

    assert_equal("yum", response.cookies["test_cookie"])
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end

  def teardown
    @client.shutdown
  end
end