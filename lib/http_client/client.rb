module HTTP
  class Client
    def initialize(options = {})
      host = options[:host] || "localhost"
      port = options[:port] || 8080
      protocol = options[:protocol] || "http"

      @uri_builder = URIBuilder.new(protocol, host, port)
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
      native_request = request.create_native_request(@uri_builder, @encoding)
      client = DefaultHttpClient.new(create_client_params)
      client.execute(native_request, BasicResponseHandler.new)
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
  end

  class URIBuilder
    def initialize(protocol, host, port)
      @protocol = protocol
      @host = host
      @port = port
    end

    def create_uri(path, query_string = nil)
      URIUtils.create_uri(@protocol, @host, @port, path, query_string, nil)
    end
  end

  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler = org.apache.http.impl.client.BasicResponseHandler
  BasicHttpParams = org.apache.http.params.BasicHttpParams
  CoreConnectionPNames = org.apache.http.params.CoreConnectionPNames
  SocketTimeoutException = java.net.SocketTimeoutException
end