# Copyright 2015 CareerBuilder, LLC
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
require 'json'
require_relative 'base'
module Cb
  module Clients
    class Recommendation < Base
      def self.for_job(*args)
        hash = normalize_args(args)
        hash = set_hash_defaults(hash)
        json_hash = cb_client.cb_get(Cb.configuration.uri_recommendation_for_job,
                                  query: hash)

        jobs = []

        if json_hash.key?('ResponseRecommendJob')
          if json_hash['ResponseRecommendJob'].key?('RecommendJobResults') &&
             !json_hash['ResponseRecommendJob']['RecommendJobResults'].nil?

            jobs = create_jobs json_hash, 'Job'

            cb_client.append_api_responses(jobs, json_hash['ResponseRecommendJob']['Request'])
          end

          cb_client.append_api_responses(jobs, json_hash['ResponseRecommendJob'])
        end

        cb_client.append_api_responses(jobs, json_hash)
      end

      def self.for_user(*args)
        hash = normalize_args(args)
        hash = set_hash_defaults(hash)
        json_hash = cb_client.cb_get(Cb.configuration.uri_recommendation_for_user,
                                  query: hash)

        jobs = []

        if json_hash.key?('ResponseRecommendUser')

          if json_hash['ResponseRecommendUser'].key?('RecommendJobResults') &&
             !json_hash['ResponseRecommendUser']['RecommendJobResults'].nil?

            jobs = create_jobs json_hash, 'User'

            cb_client.append_api_responses(jobs, json_hash['ResponseRecommendUser']['Request'])
          end

          cb_client.append_api_responses(jobs, json_hash['ResponseRecommendUser'])
        end

        cb_client.append_api_responses(jobs, json_hash)
      end

      def self.for_company(company_did)
        json_hash = cb_client.cb_get(Cb.configuration.uri_recommendation_for_company, query: { CompanyDID: company_did })
        jobs = []
        if json_hash
          api_jobs = json_hash.fetch('Results', {}).fetch('JobRecommendation', {}).fetch('Jobs', {})
          if api_jobs
            company_jobs = [api_jobs.fetch('CompanyJob', [])].flatten.compact
            company_jobs.each do |cur_job|
              jobs << Models::Job.new(cur_job)
            end
          end
          cb_client.append_api_responses(jobs, json_hash.fetch('Results', {}).fetch('JobRecommendation', {}))
          cb_client.append_api_responses(jobs, json_hash.fetch('Results', {}))
          cb_client.append_api_responses(jobs, json_hash)
        end
      end

      private

      def self.normalize_args(args)
        return args[0] if args[0].class == Hash
        {
          ExternalID: args[0],
          JobDID: args[0],
          CountLimit: args[1] || '25',
          SiteID: args[2] || '',
          CoBrand: args[3] || ''
        }
      end

      def self.set_hash_defaults(hash)
        hash[:CountLimit] ||= '25'
        hash[:HostSite] ||= Cb.configuration.host_site
        hash
      end

      def self.create_jobs(json_hash, type)
        jobs = []

        [json_hash["ResponseRecommend#{type}"]['RecommendJobResults']['RecommendJobResult']].flatten.each do |api_job|
          jobs << Models::Job.new(api_job)
        end

        jobs
      end
    end
  end
end
