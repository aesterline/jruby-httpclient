require 'helper'

class RequestEntityTest < Test::Unit::TestCase
  def test_post_request_body
    post = HTTP::Post.new("/body")
    post.body = "Here we are"

    response = @client.execute(post)
    assert_equal("Here we are", response.body)
  end

  def test_put_request_body
    post = HTTP::Put.new("/body")
    post.body = "We are there"

    response = @client.execute(post)
    assert_equal("We are there", response.body)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end

  def teardown
    @client.shutdown
  end
end