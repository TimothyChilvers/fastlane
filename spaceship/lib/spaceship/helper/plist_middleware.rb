require 'faraday'
require 'plist'

module FaradayMiddleware
  class PlistMiddleware < Faraday::Middleware
    def on_complete(env)
      return unless parseable_content_type?(env.response_headers['content-type'])
      return unless env.body.respond_to?(:to_str)

      body = env.body.to_str.force_encoding("UTF-8")
      env.body = Plist.parse_xml(body)
    end

    private

    def parseable_content_type?(content_type)
      content_type.to_s.match?(/\bplist(?:;|$)/)
    end
  end
end

Faraday::Response.register_middleware(plist: FaradayMiddleware::PlistMiddleware)
