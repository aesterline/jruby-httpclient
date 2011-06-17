module HTTP
  class Client
    attr_reader :protocol, :host, :port, :timeout_in_seconds

    def initialize(options = {})
      @host = options[:host] || "localhost"
      @port = options[:port] || 8080
      @protocol = options[:protocol] || "http"
      @timeout_in_seconds = options[:timeout_in_seconds] || 30
    end

    def get(path, options = {})
      params = options.collect { |key, value| BasicNameValuePair.new(key.to_s, value.to_s) }
      query_string = URLEncodedUtils.format(params, "UTF-8")
      uri = URIUtils.create_uri(@protocol, @host, @port, path, query_string, nil)

      make_request(HttpGet.new(uri))
    end

    def post(path, options = {})
      params = options.collect { |key, value| BasicNameValuePair.new(key.to_s, value.to_s) }

      post = HttpPost.new(URIUtils.create_uri(@protocol, @host, @port, path, nil, nil))
      post.entity = UrlEncodedFormEntity.new(params, "UTF-8")

      make_request(post)
    end

    private
    def make_request(request)
      client = DefaultHttpClient.new(create_client_params)
      client.execute(request, BasicResponseHandler.new)
    rescue SocketTimeoutException
      raise Timeout::Error, "timed out after #{timeout_in_seconds} seconds"
    ensure
      client.connection_manager.shutdown
    end

    def create_client_params
      params = BasicHttpParams.new
      DefaultHttpClient.set_default_http_params(params)
      params.set_int_parameter(CoreConnectionPNames::SO_TIMEOUT, @timeout_in_seconds * 1000)
    end
  end

  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler = org.apache.http.impl.client.BasicResponseHandler
  HttpGet = org.apache.http.client.methods.HttpGet
  HttpPost = org.apache.http.client.methods.HttpPost
  BasicNameValuePair = org.apache.http.message.BasicNameValuePair
  URIUtils = org.apache.http.client.utils.URIUtils
  URLEncodedUtils = org.apache.http.client.utils.URLEncodedUtils
  UrlEncodedFormEntity = org.apache.http.client.entity.UrlEncodedFormEntity
  BasicHttpParams = org.apache.http.params.BasicHttpParams
  CoreConnectionPNames = org.apache.http.params.CoreConnectionPNames
  SocketTimeoutException = java.net.SocketTimeoutException

end