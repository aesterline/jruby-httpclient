require 'helper'

class ClientHeadersTest < Test::Unit::TestCase
  def test_get_headers
    get = HTTP::Get.new("/echo_header")
    get.add_headers(:test_header => "get testing")

    response = @client.execute(get)
    assert_equal("get testing", response.body)
  end

  def test_post_headers
    get = HTTP::Post.new("/echo_header")
    get.add_headers(:test_header => "post testing")

    response = @client.execute(get)
    assert_equal("post testing", response.body)
  end

  def test_delete_headers
    get = HTTP::Delete.new("/echo_header")
    get.add_headers(:test_header => "post testing")

    response = @client.execute(get)
    assert_equal("post testing", response.body)
  end

  def test_put_headers
    get = HTTP::Put.new("/echo_header")
    get.add_headers(:test_header => "post testing")

    response = @client.execute(get)
    assert_equal("post testing", response.body)
  end

  def test_multiple_calls_to_add_headers_should_prefer_last_set_of_headers
    get = HTTP::Get.new("/echo_header")
    get.add_headers(:test_header => "get testing")
    get.add_headers(:test_header => "should prefer this one")

    response = @client.execute(get)
    assert_equal("should prefer this one", response.body)
  end

  def test_should_be_able_to_add_content_type
    get = HTTP::Get.new("/echo_header", :header => 'content-type')
    get.content_type = 'text/xml'

    response = @client.execute(get)
    assert_equal('text/xml', response.body)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end

  def teardown
    @client.shutdown
  end
end