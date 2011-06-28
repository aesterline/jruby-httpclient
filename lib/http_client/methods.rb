module HTTP
  class Request
    def self.create_type(&native_request_factory)
      Class.new do
        def initialize(path, params = {})
          @path = path
          @params = params
          @headers = {}
        end

        def add_headers(headers)
          @headers.merge!(headers)
        end

        def content_type=(type)
          add_headers({'content-type' => type})
        end

        def body=(request_body)
          @body = request_body
        end

        def basic_auth(username, password)
          @username = username
          @password = password
        end

        def make_native_request(client, uri_builder, encoding, handler=nil)
          request = create_native_request(uri_builder, encoding)
          request.entity = StringEntity.new(@body) unless @body.nil?

          unless @username.nil?
            client.credentials_provider.set_credentials(AuthScope::ANY, UsernamePasswordCredentials.new(@username, @password))
          end

          if handler
            client.execute(request, handler)
          else
            client.execute(request)
          end
        end

        private
        define_method(:create_native_request) do |uri_builder, encoding|
          params = @params.collect { |key, value| BasicNameValuePair.new(key.to_s, value.to_s) }
          request = native_request_factory.call(uri_builder, @path, params, encoding)

          @headers.each { |name, value| request.add_header(name.to_s, value.to_s) }

          request
        end
      end
    end
  end

  Post = Request.create_type do |uri_builder, path, params, encoding|
    post = HttpPost.new(uri_builder.create_uri(path))
    post.entity = UrlEncodedFormEntity.new(params, encoding)
    post
  end

  Get = Request.create_type do |uri_builder, path, params, encoding|
    query_string = URLEncodedUtils.format(params, encoding)
    get = HttpGet.new(uri_builder.create_uri(path, query_string))
    get
  end

  Delete = Request.create_type do |uri_builder, path|
    HttpDelete.new(uri_builder.create_uri(path))
  end

  Put = Request.create_type do |uri_builder, path|
    HttpPut.new(uri_builder.create_uri(path))
  end

  private
  HttpGet = org.apache.http.client.methods.HttpGet
  HttpPost = org.apache.http.client.methods.HttpPost
  HttpDelete = org.apache.http.client.methods.HttpDelete
  HttpPut = org.apache.http.client.methods.HttpPut
  BasicNameValuePair = org.apache.http.message.BasicNameValuePair
  URIUtils = org.apache.http.client.utils.URIUtils
  URLEncodedUtils = org.apache.http.client.utils.URLEncodedUtils
  UrlEncodedFormEntity = org.apache.http.client.entity.UrlEncodedFormEntity
  AuthScope = org.apache.http.auth.AuthScope
  UsernamePasswordCredentials = org.apache.http.auth.UsernamePasswordCredentials
  StringEntity = org.apache.http.entity.StringEntity
end