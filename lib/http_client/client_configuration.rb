module HTTP
  BasicHttpParams = org.apache.http.params.BasicHttpParams
  HttpHost = org.apache.http.HttpHost
  CoreProtocolPNames = org.apache.http.params.CoreProtocolPNames
  CoreConnectionPNames = org.apache.http.params.CoreConnectionPNames
  ConnRoutePNames = org.apache.http.conn.params.ConnRoutePNames
  CookieSpecPNames = org.apache.http.cookie.params.CookieSpecPNames
  AuthPNames = org.apache.http.auth.params.AuthPNames
  ClientPNames = org.apache.http.client.params.ClientPNames
  CookiePolicy = org.apache.http.client.params.CookiePolicy

  CLIENT_CONFIGURATION_PARAMETERS = {
      :protocol_version => HTTP::CoreProtocolPNames::PROTOCOL_VERSION,
      :strict_transfer_encoding => HTTP::CoreProtocolPNames::STRICT_TRANSFER_ENCODING,
      :http_element_charset => HTTP::CoreProtocolPNames::HTTP_ELEMENT_CHARSET,
      :use_expect_continue => HTTP::CoreProtocolPNames::USE_EXPECT_CONTINUE,
      :wait_for_continue => HTTP::CoreProtocolPNames::WAIT_FOR_CONTINUE,
      :user_agent => HTTP::CoreProtocolPNames::USER_AGENT,
      :tcp_nodelay => HTTP::CoreConnectionPNames.TCP_NODELAY,
      :so_timeout => HTTP::CoreConnectionPNames.SO_TIMEOUT,
      :so_linger => HTTP::CoreConnectionPNames.SO_LINGER,
      :so_reuseaddr => HTTP::CoreConnectionPNames.SO_REUSEADDR,
      :socket_buffer_size => HTTP::CoreConnectionPNames.SOCKET_BUFFER_SIZE,
      :connection_timeout => HTTP::CoreConnectionPNames.CONNECTION_TIMEOUT,
      :max_line_length => HTTP::CoreConnectionPNames.MAX_LINE_LENGTH,
      :max_header_count => HTTP::CoreConnectionPNames.MAX_HEADER_COUNT,
      :stale_connection_check => HTTP::CoreConnectionPNames.STALE_CONNECTION_CHECK,
      # :forced_route             => HTTP::ConnRoutePNames::FORCED_ROUTE, # not implemented
      :local_address => HTTP::ConnRoutePNames::LOCAL_ADDRESS,
      :default_proxy => HTTP::ConnRoutePNames::DEFAULT_PROXY,
      :date_patterns => HTTP::CookieSpecPNames::DATE_PATTERNS,
      :single_cookie_header => HTTP::CookieSpecPNames::SINGLE_COOKIE_HEADER,
      :credential_charset => HTTP::AuthPNames::CREDENTIAL_CHARSET,
      :cookie_policy => HTTP::ClientPNames::COOKIE_POLICY,
      :handle_authentication => HTTP::ClientPNames::HANDLE_AUTHENTICATION,
      :handle_redirects => HTTP::ClientPNames::HANDLE_REDIRECTS,
      :max_redirects => HTTP::ClientPNames::MAX_REDIRECTS,
      :allow_circular_redirects => HTTP::ClientPNames::ALLOW_CIRCULAR_REDIRECTS,
      :virtual_host => HTTP::ClientPNames::VIRTUAL_HOST,
      :default_host => HTTP::ClientPNames::DEFAULT_HOST
      # :default_headers          => HTTP::ClientPNames::DEFAULT_HEADERS, # not implemented
      # :connection_manager_factory_class_name => HTTP::ClientPNames::CONNECTION_MANAGER_FACTORY_CLASS_NAME # not implemented
  }

  class ClientConfiguration
    DEFAULT_TIMEOUT = 30_000

    CLIENT_CONFIGURATION_PARAMETERS.each do |method_name, param_class|
      define_method(method_name) do
        params.get_parameter param_class
      end

      define_method("#{method_name}=") do |arg|
        arg.add_to_params(params, CLIENT_CONFIGURATION_PARAMETERS[method_name])
      end
    end

    def initialize(options = {})
      self.so_timeout = DEFAULT_TIMEOUT

      options.each do |parameter_name, parameter_value|
        setter_name = "#{parameter_name}="
        self.send(setter_name, parameter_value) if self.respond_to?(setter_name)
      end
    end

    def build_http_client
      DefaultHttpClient.new(params)
    end

    def protocol_version=(version_string)
      protocol, major_version, minor_version = version_string.split(/[\.|\s|\/]/)
      params.set_parameter HTTP::CoreProtocolPNames::PROTOCOL_VERSION, org.apache.http.ProtocolVersion.new(protocol, major_version.to_i, minor_version.to_i)
    end

    def local_address=(local_addr_str)
      params.set_parameter HTTP::ConnRoutePNames::LOCAL_ADDRESS, java.net.InetAddress.getByName(local_addr_str)
    end

    def default_proxy=(host)
      set_host_parameter(HTTP::ConnRoutePNames::DEFAULT_PROXY, host)
    end

    def virtual_host=(host)
      set_host_parameter(HTTP::ClientPNames::VIRTUAL_HOST, host)
    end

    def default_host=(host)
      set_host_parameter(HTTP::ClientPNames::DEFAULT_HOST, host)
    end

    def timeout_in_seconds=(timeout)
      self.so_timeout = timeout * 1000
    end

    private
    def set_host_parameter(parameter_name, host)
      uri = URI.parse host
      params.set_parameter(parameter_name, HTTP::HttpHost.new(uri.host, uri.port, uri.scheme))
    end

    def params
      @params ||= default_params
    end

    def default_params
      params = BasicHttpParams.new
      DefaultHttpClient.set_default_http_params(params)
      params
    end
  end
end

class Integer
  def add_to_params(params, param_name)
    params.set_int_parameter(param_name, self)
  end
end

class TrueClass
  def add_to_params(params, param_name)
    params.set_boolean_parameter(param_name, self)
  end
end

class FalseClass
  def add_to_params(params, param_name)
    params.set_boolean_parameter(param_name, self)
  end
end

class Object
  def add_to_params(params, param_name)
    params.set_parameter(param_name, self)
  end
end