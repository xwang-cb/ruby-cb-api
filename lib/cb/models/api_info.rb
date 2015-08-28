module CB
  module Models
    class APIInfo < Struct.new(:api_call_type, :path, :options, :api_caller, :response, :elapsed_time)
    end
  end
end
