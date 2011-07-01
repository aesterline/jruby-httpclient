module HTTP
  module TestServer
    SERVER = WEBrick::HTTPServer.new(:Port => 8080)

    def self.start_server
      SERVER.mount('/echo', EchoServlet)
      SERVER.mount('/slow', SlowServlet)
      SERVER.mount('/echo_header', HeaderEchoServlet)
      SERVER.mount('/protected', ProtectedServlet)
      SERVER.mount('/body', BodyServlet)
      SERVER.mount('/redirect', RedirectServlet)
      SERVER.mount('/set_cookie', SetCookieServlet)
      SERVER.mount('/echo_cookie', EchoCookieServlet)
      SERVER.mount('/set_header', SetHeaderServlet)
      Thread.new { SERVER.start }
    end

    class SetHeaderServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        response["Test-Header"] = "FooBar"
      end
    end

    class SetCookieServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        response.cookies << WEBrick::Cookie.new("test_cookie", request.query['cookie'])
      end
    end

    class EchoCookieServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        puts request.cookies.length
        cookie = request.cookies.find { |c| c.name == "test_cookie" }
        response.body = cookie.value
      end
    end

    class RedirectServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        response.set_redirect(WEBrick::HTTPStatus::MovedPermanently, "/echo?content=#{request.query['content']}")
      end
    end

    class BodyServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_POST(request, response)
        response.status = 200
        response.body = request.body
      end

      def do_PUT(request, response)
        response.status = 200
        response.body = request.body
      end
    end

    class ProtectedServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        WEBrick::HTTPAuth.basic_auth(request, response, "Mine") do |user, pass|
          user == "user" && pass == "Password"
        end

        response.status = 200
        response.body = "Logged In"
      end
    end

    class HeaderEchoServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        echo_header(request, response)
      end

      def do_POST(request, response)
        echo_header(request, response)
      end

      def do_DELETE(request, response)
        echo_header(request, response)
      end

      def do_PUT(request, response)
        echo_header(request, response)
      end

      private
      def echo_header(request, response)
        header_to_echo = request.query['header'] || 'test_header'

        response.status = 200
        response['Content-Type'] = 'text/plain'
        response.body = request.header[header_to_echo].first
      end
    end

    class EchoServlet < WEBrick::HTTPServlet::AbstractServlet

      def do_GET(request, response)
        echo(request, response)
      end

      def do_POST(request, response)
        echo(request, response)
      end

      def do_DELETE(request, response)
        echo(request, response, "delete")
      end

      def do_PUT(request, response)
        echo(request, response, "put")
      end

      private
      def echo(request, response, canned_response = nil)
        response.status = 200
        response['Content-Type'] = 'text/plain'
        response.body = canned_response || request.query['content']
      end
    end

    class SlowServlet < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        sleep_in_seconds = request.query["sleep"] || 30
        sleep sleep_in_seconds.to_i

        response.status = 200
        response['Content-Type'] = 'text/plain'
        response.body = "Done"
      end
    end
  end
end