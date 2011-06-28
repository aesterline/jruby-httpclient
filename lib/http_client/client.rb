require 'uri'

module HTTP
  class Client
    def initialize(*params)
      options = parse_options(params)

      host = options[:host] || "localhost"
      port = options[:port] || 8080
      protocol = options[:scheme] || "http"
      base_path = options[:base_path] || ""

      @uri_builder = URIBuilder.new(protocol, host, port, base_path)
      @timeout_in_seconds = options[:timeout_in_seconds] || 30
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
      client = DefaultHttpClient.new(create_client_params)

      request.make_native_request(client, @uri_builder, @encoding)
    rescue SocketTimeoutException
      raise Timeout::Error, "timed out after #{@timeout_in_seconds} seconds"
    ensure
      client.connection_manager.shutdown
    end

    private
    def create_client_params
      params = BasicHttpParams.new
      DefaultHttpClient.set_default_http_params(params)
      params.set_int_parameter(CoreConnectionPNames::SO_TIMEOUT, @timeout_in_seconds * 1000)
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

  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  BasicHttpParams = org.apache.http.params.BasicHttpParams
  CoreConnectionPNames = org.apache.http.params.CoreConnectionPNames
  SocketTimeoutException = java.net.SocketTimeoutException
end