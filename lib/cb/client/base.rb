require 'cb/models/api_info'

require 'httparty'
require 'observer'

module CB
  module Client
    class MissingParams < StandardError; end

    class Base
      include HTTParty, Observable
      base_uri 'https://api.careerbuilder.com'
      DEFAULT_TIMEOUT = 15

      attr_reader :default_params, :headers, :timeout

      def initialize(config = {})
        modify_base_uri(config[:uri])
        set_default_params(config[:default_params])
        set_headers(config[:headers])
        set_timeout(config[:timeout])
        tack_on_observers(config[:observers])
      end

      private

      [:get, :post, :put, :delete, :head].each do |verb|
        define_method(verb) do |path, opts|
          start_time = Time.now.to_f
          opts.merge!(default_params: @default_params, headers: @headers, timeout: @timeout)
          before_request(self, verb, path, opts)
          begin
            resp = self.class.public_send(verb, path, opts)
          ensure
            after_request(self, verb, path, opts, resp, Time.now.to_f - start_time)
          end
          resp
        end
      end

      def modify_base_uri(uri)
        self.class.base_uri(uri) if uri
      end

      def set_default_params(params)
        @default_params ||= {}
        @default_params = shallow_symbolize_hash_keys(params) if params.is_a?(Hash)
        raise MissingParams.new(:developerkey) unless @default_params.has_key?(:developerkey)
      end

      def set_headers(h)
        @headers ||= {}
        @headers = shallow_stringify_hash_keys(h) if h.is_a?(Hash)
      end

      def set_timeout(t)
        @timeout ||= DEFAULT_TIMEOUT
        @timeout = t if t && (t.is_a?(Fixnum) || t.is_a?(Float))
      end

      def shallow_symbolize_hash_keys(h)
        h.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
      end

      def shallow_stringify_hash_keys(h)
        h.inject({}) { |memo, (k, v)| memo[k.to_s] = v; memo }
      end

      def tack_on_observers(observers)
        if observers.is_a?(Array)
          observers.each do |klass|
            add_observer(klass)
          end
        end
      end

      def generate_api_info(name, path, options, api_caller, response, elapsed_time)
        CB::Models::APIInfo.new(name, path, options, api_caller, response, elapsed_time)
      end

      def before_request(klass, verb, path, options)
        api_event(generate_api_info(:"cb_#{ verb }_before", path, options, klass, nil, 0.0))
      end

      def after_request(klass, verb, path, options, response, elapsed_time)
        api_event(generate_api_info(:"cb_#{ verb }_after", path, options, klass, response, elapsed_time))
      end

      def api_event(api_info)
        changed
        notify_observers(api_info)
      end
    end
  end
end
