require 'uri'
module HTTP
  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler = org.apache.http.impl.client.BasicResponseHandler
  SocketTimeoutException = java.net.SocketTimeoutException

  class Client
    DEFAULT_TIMEOUT = 30_000
    include HTTP::Parameters

    def initialize(options = {})
      self.so_timeout = DEFAULT_TIMEOUT

      if options[:disable_response_handler]
        @response_handler = nil
      elsif options[:response_handler]
        @response_handler = options[:response_handler]
      else
        @response_handler = BasicResponseHandler.new
      end

      @encoding = options[:encoding] || "UTF-8"

      # Set options from the rest of the options-hash
      options.each do |parameter_name, parameter_value|
        setter_name = "#{parameter_name}="
        self.send(setter_name, parameter_value) if self.respond_to?(setter_name)
      end
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
      client = DefaultHttpClient.new(params)

      request.make_native_request(client, @encoding, @response_handler)
    rescue SocketTimeoutException
      raise Timeout::Error, "timed out after #{so_timeout} ms"
    ensure
      client.connection_manager.shutdown
    end
  end
end