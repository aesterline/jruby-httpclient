require 'helper'

class TestClientParameters < Test::Unit::TestCase
  def test_timeout
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :timeout_in_seconds => 2)

    assert_raises(Timeout::Error) do
      client.get("/slow", :sleep => "30")
    end
  end
  
  def test_protocol_version
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :protocol_version => "HTTP 1.0")
    result = client.get("/echo", :content => "hello")
    # We did set the parameter, right?
    assert_equal(client.protocol_version.to_s, "HTTP/1.0")
    # Make sure the client is still working (badly set params would prevent this)
    assert_equal("hello", result)
  end
  
  def test_strict_transfer_encodeing
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :strict_transfer_encoding => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.strict_transfer_encoding, true)
    assert_equal("hello", result)
  end
  
  def test_http_element_charset
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :http_element_charset => "ASCII")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.http_element_charset, "ASCII")
    assert_equal("hello", result)    
  end
  
  def test_use_expect_continue
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :use_expect_continue => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.use_expect_continue, true)
    assert_equal("hello", result)
  end
  
  def test_wait_for_continue
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :wait_for_continue => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.wait_for_continue, true)
    assert_equal("hello", result)
  end
  
  def test_user_agent
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :user_agent => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.0.3) Gecko/2008092414 Firefox/3.0.3")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.user_agent, "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.0.3) Gecko/2008092414 Firefox/3.0.3")
    assert_equal("hello", result)
  end
  
  def test_tcp_nodelay
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :tcp_nodelay => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.tcp_nodelay, true)
    assert_equal("hello", result)
  end
  
  def test_so_linger
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :so_linger => 3000)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.so_linger, 3000)
    assert_equal("hello", result)
  end
  
  def test_so_reuseaddr
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :so_reuseaddr => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.so_reuseaddr, true)
    assert_equal("hello", result)
  end
  
  def test_socket_buffer_size
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :socket_buffer_size => 10000)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.socket_buffer_size, 10000)
    assert_equal("hello", result)
  end
  
  def test_connection_timeout
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :connection_timeout => 2)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.connection_timeout, 2)
    assert_equal("hello", result)
  end
  
  def test_max_line_length
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :max_line_length => 2)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.max_line_length, 2)
    assert_equal("hello", result)
  end
  
  def test_max_header_count
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :max_header_count => 10)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.max_header_count, 10)
    assert_equal("hello", result)    
  end
  
  def test_stale_connection_check
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :stale_connection_check => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.stale_connection_check, true)
    assert_equal("hello", result)
  end
  
  def test_local_address
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :local_address => "127.0.0.1")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.local_address.get_host_address, "127.0.0.1")
    assert_equal("hello", result)    
  end
  
  def test_default_proxy
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :default_proxy => "http://127.0.0.1:8080")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.default_proxy.to_s, "http://127.0.0.1:8080")
    assert_equal("hello", result)    
  end
  
  def test_date_patterns
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :date_patterns => ["MDy"])
    result = client.get("/echo", :content => "hello")
    assert(client.date_patterns.include? 'MDy')
    assert_equal("hello", result)        
  end
  
  def test_single_cookie_header
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :single_cookie_header => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.single_cookie_header, true)
    assert_equal("hello", result)
  end
  
  def test_credential_charset
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :credential_charset => "ASCII")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.credential_charset, "ASCII")
    assert_equal("hello", result)
  end
  
  def test_cookie_policy
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :cookie_policy => "RFC2109")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.cookie_policy, "RFC2109")
    assert_equal("hello", result)
  end
  
  def test_handle_authentication
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :handle_authentication => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.handle_authentication, true)
    assert_equal("hello", result)
  end
  
  def test_handle_redirects
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :handle_redirects => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.handle_redirects, true)
    assert_equal("hello", result)
  end
  
  def test_max_redirects
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :max_redirects => 1)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.max_redirects, 1)
    assert_equal("hello", result)
  end
  
  def test_allow_circular_redirects
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :allow_circular_redirects => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(client.allow_circular_redirects, true)
    assert_equal("hello", result)
  end
  
  def test_virtual_host
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :virtual_host => "http://127.0.0.1:80")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.virtual_host.to_s, "http://127.0.0.1:80")
    assert_equal("hello", result)
  end

  def test_default_host
    client = HTTP::Client.new(:default_host => "http://localhost:8080")
    result = client.get("/echo", :content => "hello")
    assert_equal(client.default_host.to_s, "http://localhost:8080")
    assert_equal("hello", result)
  end
  
  def test_disable_response_handler
    client = HTTP::Client.new(:default_host => "http://localhost:8080", :disable_response_handler => true)
    result = client.get("/echo", :content => "hello")
    assert_equal(Java::OrgApacheHttpMessage::BasicHttpResponse, result.class)
  end
end