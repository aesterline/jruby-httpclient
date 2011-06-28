require 'helper'

class CookieTest < Test::Unit::TestCase
  def test_cookies_can_be_remembered
    @client.get("/set_cookie", :cookie => "nom nom nom")
    result = @client.get("/echo_cookie")

    assert_equal("nom nom nom", result)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080", :cookie_policy => HTTP::CookiePolicy::BROWSER_COMPATIBILITY)
  end

  def teardown
    @client.shutdown
  end
end