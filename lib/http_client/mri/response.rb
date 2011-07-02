module HTTP
  class Response
    attr_reader :status_code, :body

    def initialize(native_response)
      @native_response = native_response
      @status_code = native_response.code.to_i
      @body = native_response.body
    end

    def headers
      @native_response
    end

    def cookies
      native_cookies = CGI::Cookie.parse(@native_response['set-cookie'])
      cookies = {}
      native_cookies.each {|name, cookie| cookies[name] = cookie.value.first}
      cookies
    end
  end
end