module HTTP
  class Response
    attr_reader :body

    def initialize(native_response)
      @body = EntityUtils.to_string(native_response.entity)
    end

  end

  private
  EntityUtils = org.apache.http.util.EntityUtils
end