require 'uri'
module HTTP
  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler = org.apache.http.impl.client.BasicResponseHandler
  SocketTimeoutException = java.net.SocketTimeoutException

  class Client
    def initialize(options = {})
      if options[:disable_response_handler]
        @response_handler = nil
      elsif options[:response_handler]
        @response_handler = options[:response_handler]
      else
        @response_handler = BasicResponseHandler.new
      end

      @encoding = options[:encoding] || "UTF-8"

      @client = HTTP::ClientConfiguration.new(options).build_http_client
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
      request.make_native_request(@client, @encoding, @response_handler)
    rescue SocketTimeoutException => e
      raise Timeout::Error, e.message
    end

    def shutdown
      @client.connection_manager.shutdown
    end
  end
end