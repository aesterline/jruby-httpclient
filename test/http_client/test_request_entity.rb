require 'helper'

class RequestEntityTest < Test::Unit::TestCase
  def test_post_request_body
    post = HTTP::Post.new("/body")
    post.body = "Here we are"

    result = @client.execute(post)
    assert_equal("Here we are", result)
  end

  def test_put_request_body
    post = HTTP::Put.new("/body")
    post.body = "We are there"

    result = @client.execute(post)
    assert_equal("We are there", result)
  end

  def setup
    @client = HTTP::Client.new(:default_host => "http://localhost:8080")
  end
end