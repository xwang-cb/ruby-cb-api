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
require 'spec_helper'

module Cb
  describe Cb::Requests::User::TemporaryPassword do
    context 'initialize without arguments' do
      context 'without arguments' do
        before(:each) { @request = Cb::Requests::User::TemporaryPassword.new({}) }

        it 'should be correctly configured' do
          expect(@request.endpoint_uri).to eq(Cb.configuration.uri_user_temp_password)
          expect(@request.http_method).to eq(:get)
        end

        it 'should have a basic query string' do
          expect(@request.query).to eq('ExternalID' => nil)
        end

        it 'should have basic headers' do
          expect(@request.headers).to eq(nil)
        end

        it 'should have a basic body' do
          expect(@request.body).to eq(nil)
        end
      end

      context 'with arguments' do
        before :each do
          @request = Cb::Requests::User::TemporaryPassword.new(external_id: 'external id')
        end

        it 'should be correctly configured' do
          expect(@request.endpoint_uri).to eq(Cb.configuration.uri_user_temp_password)
          expect(@request.http_method).to eq(:get)
        end

        it 'should have a basic query string' do
          expect(@request.query).to eq('ExternalID' => 'external id')
        end

        it 'should have basic headers' do
          expect(@request.headers).to eq(nil)
        end

        it 'should have a basic body' do
          expect(@request.body).to eq(nil)
        end
      end
    end
  end
end
