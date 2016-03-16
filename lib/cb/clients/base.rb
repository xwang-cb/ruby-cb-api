# Copyright 2016 CareerBuilder, LLC
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
module Cb
  module Clients
    class Base
      def self.cb_client
        @cb_client ||= Cb::Utils::Api.instance
      end

      def self.headers(args)
        {
            'Accept' => 'application/json',
            'Authorization' => "Bearer #{ args[:oauth_token] }",
            'Content-Type' => 'application/json'
        }
      end
    end
  end
end
