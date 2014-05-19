module Cb
  class Client
    attr_reader :callback_block

    def initialize(&block)
      @callback_block = block
    end

    def execute(request)
      api_response = call_api(request)
      response_class = Cb::Utils::ResponseMap.finder(request.class)
      response_class.new api_response
    end

    private

    def call_api(request)
      cb_client.method(:"cb_#{request.http_method}").call(
        request.endpoint_uri,
        {
          query: request.query,
          headers: request.headers,
          body: request.body
        },
        &@callback_block)
    end

    def cb_client
      Cb::Utils::Api.instance
    end
  end
end
