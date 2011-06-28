require 'helper'

class BasicAuthTest < Test::Unit::TestCase
  def test_get_can_authenticate
    get = HTTP::Get.new("/protected")
    get.basic_auth("user", "Password")

    response = @client.execute(get)

    assert_equal("Logged In", response)
  end

  def setup
    @client = HTTP::Client.new(:host => "localhost", :port => 8080)
  end
end