module HTTP
  module TestServer
    SERVER = WEBrick::HTTPServer.new(:Port => 8080)

    def self.start_server
      SERVER.mount('/echo', EchoServlet)
      SERVER.mount('/slow', SlowServlet)
      Thread.new { SERVER.start }
    end

    class EchoServlet < WEBrick::HTTPServlet::AbstractServlet

      def do_GET(request, response)
        echo(request, response)
      end

      def do_POST(request, response)
        echo(request, response)
      end

      private
      def echo(request, response)
        response.status = 200
        response['Content-Type'] = 'text/plain'
        response.body = request.query['content']
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