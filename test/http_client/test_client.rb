require 'helper'

class TestClient < Test::Unit::TestCase

  def test_simple_get
    client = HTTP::Client.new(:port => 8080)
    result = client.get("/repeat", :content => "hello")

    assert_equal("hello", result)
  end

  def setup
    @server = WEBrick::HTTPServer.new(:Port => 8080)
    @server.mount('/repeat', RepeatingServlet)
    Thread.new { @server.start }
  end

  def teardown
    @server.stop
  end

end

class RepeatingServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = request['content']
  end
end