require 'helper'

class TestClient < Test::Unit::TestCase

  def test_simple_get
    client = HTTP::Client.new(:host => "localhost", :port => 8080)
    result = client.get("/repeat", :content => "hello")

    assert_equal("hello", result)
  end

  def test_simple_post
    client = HTTP::Client.new(:host => "localhost", :port => 8080)
    result = client.post("/repeat", :content => "world")

    assert_equal("world", result)
  end

  def test_timeout
    client = HTTP::Client.new(:host => "localhost", :port => 8080)
    client.timeout_in_seconds = 2

    assert_raises(Timeout::Error) do
      client.get("/slow", :sleep => "30")
    end
  end

  def setup
    @server = WEBrick::HTTPServer.new(:Port => 8080)
    @server.mount('/repeat', RepeatingServlet)
    @server.mount('/slow', SlowServlet)
    Thread.new { @server.start }
  end

  def teardown
    @server.shutdown
  end

end

class RepeatingServlet < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    echo(request, response)
  end

  def do_POST(request, response)
    echo(request, response)
  end

  private
  def echo(request, response)
    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = request.query['content']
  end
end

class SlowServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    sleep_in_seconds = request.query["sleep"] || 30
    sleep sleep_in_seconds.to_i

    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = "Done"
  end
end