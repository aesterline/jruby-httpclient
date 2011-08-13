module HTTP
  class Response
    attr_reader :headers, :cookies

    def initialize(native_response, cookies)
      @native_response = native_response
      @headers = Headers.new(native_response)
      @cookies = Cookies.new(cookies)
    end

    def body
      @body ||= EntityUtils.to_string(@native_response.entity)
    end

    def status_code
      @native_response.status_line.status_code
    end
  end

  private
  EntityUtils = org.apache.http.util.EntityUtils

  class Headers
    def initialize(native_response)
      @native_response = native_response
    end

    def [](header_name)
      @native_response.get_first_header(header_name).value
    end
    
    def to_hash
      Hash[ @native_response.get_all_headers.map{ |h| [h.get_name, h.get_value] } ]
    end
    
    def each
      i = @native_response.get_all_headers.each do |h|
        yield h.get_name, h.get_value
      end
    end
  end

  class Cookies
    def initialize(cookies)
      @cookies = cookies
    end

    def [](cookie_name)
      @cookies.find {|cookie| cookie.name == cookie_name }.value
    end
  end
end