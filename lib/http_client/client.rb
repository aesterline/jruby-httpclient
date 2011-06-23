require 'uri'

module HTTP
  DefaultHttpClient      = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler   = org.apache.http.impl.client.BasicResponseHandler
  BasicHttpParams        = org.apache.http.params.BasicHttpParams
  CoreProtocolPNames     = org.apache.http.params.CoreProtocolPNames
  CoreConnectionPNames   = org.apache.http.params.CoreConnectionPNames
  ConnRoutePNames        = org.apache.http.conn.params.ConnRoutePNames
  CookieSpecPNames       = org.apache.http.cookie.params.CookieSpecPNames
  AuthPNames             = org.apache.http.auth.params.AuthPNames
  ClientPNames           = org.apache.http.client.params.ClientPNames
  SocketTimeoutException = java.net.SocketTimeoutException
  class Client
    CLIENT_PARAM_CLASSES = {
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
      :forced_route             => HTTP::ConnRoutePNames::FORCED_ROUTE,
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
      :default_host             => HTTP::ClientPNames::DEFAULT_HOST,
      :default_headers          => HTTP::ClientPNames::DEFAULT_HEADERS,
      :connection_manager_factory_class_name => HTTP::ClientPNames::CONNECTION_MANAGER_FACTORY_CLASS_NAME
    }
    
    def initialize(*params)
      # Strip out the client params into another hash
      @client_params = {}
      params.each do |k,v|
        @client_params[k] = params.delete(k) if CLIENT_PARAM_CLASSES[k]
      end
      
      # Parse the remaining options
      options = parse_options(params)

      host = options[:host] || "localhost"
      port = options[:port] || 8080
      protocol = options[:scheme] || "http"
      base_path = options[:base_path] || ""

      @uri_builder = URIBuilder.new(protocol, host, port, base_path)
      @client_params[:so_timeout] = options[:timeout_in_seconds] ? options[:timeout_in_seconds] * 1000 : 30000
      @encoding = options[:encoding] || "UTF-8"
    end

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
      client = DefaultHttpClient.new(create_client_params)
      client.execute(native_request, BasicResponseHandler.new)
    rescue SocketTimeoutException
      raise Timeout::Error, "timed out after #{@client_params[:so_timeout]} ms"
    ensure
      client.connection_manager.shutdown
    end

    private
    def create_client_params
      params = BasicHttpParams.new
      DefaultHttpClient.set_default_http_params(params)
      # Set any customized client parameters
      @client_params.each { |k,v| params.set_int_parameter(CLIENT_PARAM_CLASSES[k], v) }
      params
    end

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