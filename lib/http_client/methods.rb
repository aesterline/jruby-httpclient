require 'cgi'

module HTTP
  class Request
    def self.create_type(&native_request_factory)
      Class.new do
        attr_accessor :body, :encoding

        def initialize(uri, params = {})
          @uri = uri
          @params = params
          @encoding = "UTF-8"

          @headers = {}
        end

        def add_headers(headers)
          @headers.merge!(headers)
        end

        def content_type=(type)
          add_headers({'content-type' => type})
        end

        def basic_auth(username, password)
          @username = username
          @password = password
        end

        def make_native_request(client, handler=nil)
          request = create_native_request
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

        def parse_uri
          uri = URI.parse(@uri)
          [uri.scheme, uri.host, uri.port, uri.path, uri.query]
        rescue URI::InvalidURIError
          [nil, nil, nil, @uri, nil]
        end

        private
        define_method(:create_native_request) do
          scheme, host, port, path, query = parse_uri
          query_params = CGI.parse(query || "").merge(@params)

          params = query_params.collect { |key, value| BasicNameValuePair.new(key.to_s, value.to_s) }
          request = native_request_factory.call(scheme, host, port, path, params, @encoding)

          @headers.each { |name, value| request.add_header(name.to_s, value.to_s) }

          request
        end
      end
    end
  end

  Post = Request.create_type do |scheme, host, port, path, params, encoding|
    post = HttpPost.new(URIUtils.create_uri(scheme, host, port, path, nil, nil))
    post.entity = UrlEncodedFormEntity.new(params, encoding)
    post
  end

  Get = Request.create_type do |scheme, host, port, path, params, encoding|
    query_string = URLEncodedUtils.format(params, encoding)
    HttpGet.new(URIUtils.create_uri(scheme, host, port, path, query_string, nil))
  end

  Delete = Request.create_type do |scheme, host, port, path|
    HttpDelete.new(URIUtils.create_uri(scheme, host, port, path, nil, nil))
  end

  Put = Request.create_type do |scheme, host, port, path|
    HttpPut.new(URIUtils.create_uri(scheme, host, port, path, nil, nil))
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