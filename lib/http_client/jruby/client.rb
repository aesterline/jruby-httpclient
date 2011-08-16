require 'uri'
module HTTP
  DefaultHttpClient = org.apache.http.impl.client.DefaultHttpClient
  BasicResponseHandler = org.apache.http.impl.client.BasicResponseHandler
  SocketTimeoutException = java.net.SocketTimeoutException

  class Client
    def initialize(options = {})
      @client = HTTP::ClientConfiguration.new(options).build_http_client
    end

    def get(params, options = {})
      read_response(Get.new(params, options))
    end
    
    def head(params, options = {})
      read_response(Head.new(params, options))
    end
    
    def options(params, options = {})
      read_response(Options.new(params, options))
    end

    def post(params, options = {})
      read_response(Post.new(params, options))
    end

    def delete(path)
      read_response(Delete.new(path))
    end

    def put(path)
      read_response(Put.new(path))
    end

    def read_response(request)
      execute(request).body
    end

    def execute(request)
      request.make_native_request(@client)
    rescue SocketTimeoutException => e
      raise Timeout::Error, e.message
    end

    def shutdown
      @client.connection_manager.shutdown
    end
  end
end