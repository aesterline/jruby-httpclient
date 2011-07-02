require 'helper'

if defined?(JRUBY_VERSION)
  class TestClientConfiguration < Test::Unit::TestCase
    def test_protocol_version
      config = HTTP::ClientConfiguration.new(:protocol_version => "HTTP 1.0")
      assert_equal(config.protocol_version.to_s, "HTTP/1.0")
    end

    def test_strict_transfer_encodeing
      config = HTTP::ClientConfiguration.new(:strict_transfer_encoding => true)
      assert_equal(config.strict_transfer_encoding, true)
    end

    def test_http_element_charset
      config = HTTP::ClientConfiguration.new(:http_element_charset => "ASCII")
      assert_equal(config.http_element_charset, "ASCII")
    end

    def test_use_expect_continue
      config = HTTP::ClientConfiguration.new(:use_expect_continue => true)
      assert_equal(config.use_expect_continue, true)
    end

    def test_wait_for_continue
      config = HTTP::ClientConfiguration.new(:wait_for_continue => true)
      assert_equal(config.wait_for_continue, true)
    end

    def test_user_agent
      user_agent_name = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.0.3) Gecko/2008092414 Firefox/3.0.3"
      config = HTTP::ClientConfiguration.new(:user_agent => user_agent_name)
      assert_equal(config.user_agent, user_agent_name)
    end

    def test_tcp_nodelay
      config = HTTP::ClientConfiguration.new(:tcp_nodelay => true)
      assert_equal(config.tcp_nodelay, true)
    end

    def test_so_linger
      config = HTTP::ClientConfiguration.new(:so_linger => 3000)
      assert_equal(config.so_linger, 3000)
    end

    def test_so_reuseaddr
      config = HTTP::ClientConfiguration.new(:so_reuseaddr => true)
      assert_equal(config.so_reuseaddr, true)
    end

    def test_socket_buffer_size
      config = HTTP::ClientConfiguration.new(:socket_buffer_size => 10000)
      assert_equal(config.socket_buffer_size, 10000)
    end

    def test_connection_timeout
      config = HTTP::ClientConfiguration.new(:connection_timeout => 2)
      assert_equal(config.connection_timeout, 2)
    end

    def test_max_line_length
      config = HTTP::ClientConfiguration.new(:max_line_length => 2)
      assert_equal(config.max_line_length, 2)
    end

    def test_max_header_count
      config = HTTP::ClientConfiguration.new(:max_header_count => 10)
      assert_equal(config.max_header_count, 10)
    end

    def test_stale_connection_check
      config = HTTP::ClientConfiguration.new(:stale_connection_check => true)
      assert_equal(config.stale_connection_check, true)
    end

    def test_local_address
      config = HTTP::ClientConfiguration.new(:local_address => "127.0.0.1")
      assert_equal(config.local_address.get_host_address, "127.0.0.1")
    end

    def test_default_proxy
      config = HTTP::ClientConfiguration.new(:default_proxy => "http://127.0.0.1:8080")
      assert_equal(config.default_proxy.to_s, "http://127.0.0.1:8080")
    end

    def test_date_patterns
      config = HTTP::ClientConfiguration.new(:date_patterns => ["MDy"])
      assert(config.date_patterns.include? 'MDy')
    end

    def test_single_cookie_header
      config = HTTP::ClientConfiguration.new(:single_cookie_header => true)
      assert_equal(config.single_cookie_header, true)
    end

    def test_credential_charset
      config = HTTP::ClientConfiguration.new(:credential_charset => "ASCII")
      assert_equal(config.credential_charset, "ASCII")
    end

    def test_cookie_policy
      config = HTTP::ClientConfiguration.new(:cookie_policy => "RFC2109")
      assert_equal(config.cookie_policy, "RFC2109")
    end

    def test_handle_authentication
      config = HTTP::ClientConfiguration.new(:handle_authentication => true)
      assert_equal(config.handle_authentication, true)
    end

    def test_handle_redirects
      config = HTTP::ClientConfiguration.new(:handle_redirects => true)
      assert_equal(config.handle_redirects, true)
    end

    def test_max_redirects
      config = HTTP::ClientConfiguration.new(:max_redirects => 1)
      assert_equal(config.max_redirects, 1)
    end

    def test_allow_circular_redirects
      config = HTTP::ClientConfiguration.new(:allow_circular_redirects => true)
      assert_equal(config.allow_circular_redirects, true)
    end

    def test_virtual_host
      config = HTTP::ClientConfiguration.new(:virtual_host => "http://127.0.0.1:80")
      assert_equal(config.virtual_host.to_s, "http://127.0.0.1:80")
    end

    def test_default_host
      config = HTTP::ClientConfiguration.new(:default_host => "http://localhost:8080")
      assert_equal(config.default_host.to_s, "http://localhost:8080")
    end
  end
end