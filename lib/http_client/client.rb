require 'uri'
module HTTP
  DefaultHttpClient      = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler   = org.apache.http.impl.client.BasicResponseHandler
  BasicHttpParams        = org.apache.http.params.BasicHttpParams
  HttpHost               = org.apache.http.HttpHost
  CoreProtocolPNames     = org.apache.http.params.CoreProtocolPNames
  CoreConnectionPNames   = org.apache.http.params.CoreConnectionPNames
  ConnRoutePNames        = org.apache.http.conn.params.ConnRoutePNames
  CookieSpecPNames       = org.apache.http.cookie.params.CookieSpecPNames
  AuthPNames             = org.apache.http.auth.params.AuthPNames
  ClientPNames           = org.apache.http.client.params.ClientPNames
  SocketTimeoutException = java.net.SocketTimeoutException
  class Client    
    CLIENT_PARAMETERS = {
      :protocol_version         => HTTP::CoreProtocolPNames::PROTOCOL_VERSION,
      :strict_transfer_encoding => HTTP::CoreProtocolPNames::STRICT_TRANSFER_ENCODING,
      :http_element_charset     => HTTP::CoreProtocolPNames::HTTP_ELEMENT_CHARSET,
      :use_expect_continue      => HTTP::CoreProtocolPNames::USE_EXPECT_CONTINUE,
      :wait_for_continue        => HTTP::CoreProtocolPNames::WAIT_FOR_CONTINUE,
      :user_agent               => HTTP::CoreProtocolPNames::USER_AGENT,
      :tcp_nodelay              => HTTP::CoreConnectionPNames.TCP_NODELAY,
      :so_timeout               => HTTP::CoreConnectionPNames.SO_TIMEOUT,
      :so_linger                => HTTP::CoreConnectionPNames.SO_LINGER,
      :so_reuseaddr             => HTTP::CoreConnectionPNames.SO_REUSEADDR,
      :socket_buffer_size       => HTTP::CoreConnectionPNames.SOCKET_BUFFER_SIZE,
      :connection_timeout       => HTTP::CoreConnectionPNames.CONNECTION_TIMEOUT,
      :max_line_length          => HTTP::CoreConnectionPNames.MAX_LINE_LENGTH,
      :max_header_count         => HTTP::CoreConnectionPNames.MAX_HEADER_COUNT,
      :stale_connection_check   => HTTP::CoreConnectionPNames.STALE_CONNECTION_CHECK,
      # :forced_route             => HTTP::ConnRoutePNames::FORCED_ROUTE, # not implemented
      :local_address            => HTTP::ConnRoutePNames::LOCAL_ADDRESS,
      :default_proxy            => HTTP::ConnRoutePNames::DEFAULT_PROXY,
      :date_patterns            => HTTP::CookieSpecPNames::DATE_PATTERNS,
      :single_cookie_header     => HTTP::CookieSpecPNames::SINGLE_COOKIE_HEADER,
      :credential_charset       => HTTP::AuthPNames::CREDENTIAL_CHARSET,
      :cookie_policy            => HTTP::ClientPNames::COOKIE_POLICY,
      :handle_authentication    => HTTP::ClientPNames::HANDLE_AUTHENTICATION,
      :handle_redirects         => HTTP::ClientPNames::HANDLE_REDIRECTS,
      :max_redirects            => HTTP::ClientPNames::MAX_REDIRECTS,
      :allow_circular_redirects => HTTP::ClientPNames::ALLOW_CIRCULAR_REDIRECTS,
      :virtual_host             => HTTP::ClientPNames::VIRTUAL_HOST,
      :default_host             => HTTP::ClientPNames::DEFAULT_HOST
      # :default_headers          => HTTP::ClientPNames::DEFAULT_HEADERS, # not implemented
      # :connection_manager_factory_class_name => HTTP::ClientPNames::CONNECTION_MANAGER_FACTORY_CLASS_NAME # not implemented
    }
    
    INTEGER_PARAMETER_SETTERS = [
      :so_timeout, :so_linger, :socket_buffer_size, :connection_timeout,
      :max_line_length, :max_header_count, :max_redirects
    ]
        
    SIMPLE_PARAMETER_SETTERS = [
      :strict_transfer_encoding, :http_element_charset, :use_expect_continue,
      :wait_for_continue, :user_agent, :tcp_nodelay, :so_reuseaddr,
      :stale_connection_check, :date_patterns, :single_cookie_header,
      :credential_charset, :cookie_policy, :handle_authentication,
      :handle_redirects, :allow_circular_redirects
    ]
        
    def initialize(*params)      
      self.class.class_eval do
        # Setup dynamic getters (setters can be more complex)
        CLIENT_PARAMETERS.each do |method_name, param_class|
          define_method method_name do
            @params.get_parameter param_class
          end
        end
        
        INTEGER_PARAMETER_SETTERS.each do |method_name|
          define_method "#{method_name}=" do |arg|
            @params.set_int_parameter CLIENT_PARAMETERS[method_name], arg
          end
        end
        
        # For those params that our simple, we'll create the setters
        SIMPLE_PARAMETER_SETTERS.each do |method_name|
          define_method "#{method_name}=" do |arg|
            @params.set_parameter CLIENT_PARAMETERS[method_name], arg
          end
        end
      end
      
      # Parse the remaining options
      options   = parse_options(params)      
      host      = options[:host] || "localhost"
      port      = options[:port] || 8080
      protocol  = options[:scheme] || "http"
      base_path = options[:base_path] || ""

      @uri_builder = URIBuilder.new(protocol, host, port, base_path)
      @encoding = options[:encoding] || "UTF-8"
      @params   = BasicHttpParams.new
      DefaultHttpClient.set_default_http_params(@params)
      
      # Handle a custom setting for "timemout_in_seconds" and or "so_timeout"
      if options[:timeout_in_seconds]
        self.so_timeout = options[:timeout_in_seconds] * 1000
      elsif options[:so_timeout]
        self.so_timeout = options[:so_timeout]
      else
        self.so_timeout = 30000
      end

      # Set options from the rest of the options-hash      
      CLIENT_PARAMETERS.each do |method_name, param_class|
        self.send("#{method_name}=", options[method_name]) if options[method_name]
      end
    end
    
    # Advanced Setters
    
    def protocol_version=(version_string)
      protocol, major_version, minor_version = version_string.split(/[\.|\s|\/]/)
      @params.set_parameter HTTP::CoreProtocolPNames::PROTOCOL_VERSION, org.apache.http.ProtocolVersion.new(protocol, major_version.to_i, minor_version.to_i)
    end    
        
    def local_address=(local_addr_str)
      @params.set_parameter HTTP::ConnRoutePNames::LOCAL_ADDRESS, java.net.InetAddress.getByName(local_addr_str)
    end
    
    def default_proxy=(host)
      uri = URI.parse host
      @params.set_parameter HTTP::ConnRoutePNames::DEFAULT_PROXY, HTTP::HttpHost.new(uri.host, uri.port, uri.scheme)
    end
    
    def virtual_host=(host)
      uri = URI.parse host
      @params.set_parameter HTTP::ClientPNames::VIRTUAL_HOST, HTTP::HttpHost.new(uri.host, uri.port, uri.scheme)
    end
    
    def default_host=(host)
      uri = URI.parse host
      @params.set_parameter HTTP::ClientPNames::DEFAULT_HOST, HTTP::HttpHost.new(uri.host, uri.port, uri.scheme)
    end
    
    # Request Methods
    
    def get(params, options = {})
      execute(Get.new(params, options))
    end

    def post(params, options = {})
      execute(Post.new(params, options))
    end

    def delete(path)
      execute(Delete.new(path))
    end

    def put(path)
      execute(Put.new(path))
    end

    def execute(request)
      native_request = request.create_native_request(@uri_builder, @encoding)
      client = DefaultHttpClient.new(@params)
      client.execute(native_request, BasicResponseHandler.new)
    rescue SocketTimeoutException
      raise Timeout::Error, "timed out after #{so_timeout} ms"
    ensure
      client.connection_manager.shutdown
    end

    private
    def parse_options(params)
      options = {}

      params.reverse.each do |param|
        if param.kind_of?(Hash)
          options = param.merge(options)
        else
          uri = URI.parse(param)
          options = {:host => uri.host, :port => uri.port, :scheme => uri.scheme, :base_path => uri.path}.merge(options)
        end
      end

      options
    end
  end

  class URIBuilder
    def initialize(protocol, host, port, base_path)
      @protocol = protocol
      @host = host
      @port = port
      @base_path = base_path
    end

    def create_uri(path, query_string = nil)
      URIUtils.create_uri(@protocol, @host, @port, "#{@base_path}#{path}", query_string, nil)
    end
  end
end