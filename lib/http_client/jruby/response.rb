module HTTP
  class Response
    attr_reader :headers, :cookies

    def initialize(native_response, cookies)
      @native_response = native_response
      @headers = Headers.new(native_response)
      @cookies = Cookies.new(cookies)
    end

    def body
      # HTTP HEAD requests have no entity, nor any body
      if @native_response.entity
        @body ||= EntityUtils.to_string(@native_response.entity)
      else
        nil
      end
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
      @native_response.get_headers(header_name).map{|h| h.get_value}.join(", ")
    end
    
    def to_s
      @native_response.get_all_headers.map(&:to_s).join("\n")
    end
    
    def to_hash
      hash = {}
      each do |name, value|
        hash[name] = hash[name] ? hash[name] + ", #{value}" : value
      end
      hash
    end
    
    def each
      @native_response.header_iterator.each do |h|
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