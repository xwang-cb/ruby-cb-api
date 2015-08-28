require 'spec_helper'

module CB::Client
  describe Base do
    context 'create client instance verifies required settings' do
      let(:base_valid_params) { { default_params: { developerkey: '123' } } }

      context 'succeeds to create base client' do
        let(:params) { base_valid_params }
        let(:client) { Base.new(params) }

        it 'with correct settings' do
          expect(client).to be_a(Base)
          expect(client.default_params).to eq(params[:default_params])
          expect(client.headers).to eq({})
          expect(client.timeout).to eq(15)
        end
      end

      context '#default_params' do
        let(:client) { Base.new(params) }

        context 'is not a hash' do
          let(:params) { { default_params: 1 } }

          it 'raises the missing params error for developerkey' do
            expect { Base.new(params) }.to raise_error(MissingParams, 'developerkey')
          end
        end

        context 'is a hash without required key' do
          let(:params) { { default_params: { other_key: :other_value } } }

          it 'raises the missing params error for developerkey' do
            expect { Base.new(params) }.to raise_error(MissingParams, 'developerkey')
          end
        end

        context 'is a hash with required key' do
          let(:params) { base_valid_params }

          it 'successfully creates the client with developerkey' do
            expect(client.default_params).to eq(params[:default_params])
          end
        end

        context 'is a hash with required key, but as a string' do
          let(:params) { { default_params: { 'developerkey' => '123' } } }

          it 'successfully creates the client with developerkey and converts the key to a symbol' do
            expect(client.default_params).to eq(base_valid_params[:default_params])
          end
        end
      end

      context '#headers' do
        let(:client) { Base.new(params) }

        context 'is not a hash' do
          let(:params) { base_valid_params.merge(headers: 1) }

          it 'gracefully handles meaningless #headers options' do
            expect(client.headers).to eq({})
          end
        end

        context 'is a hash' do
          let(:params) { base_valid_params.merge(headers: { rando: :header }) }

          it 'successfully adds the #headers with string keys' do
            expect(client.headers['rando']).to eq(params[:headers][:rando])
          end
        end
      end

      context '#timeout' do
        let(:client) { Base.new(params) }

        context 'is not a number' do
          let(:params) { base_valid_params.merge(timeout: '123') }

          it 'gracefully handles meaningless #timeout option' do
            expect(client.timeout).to eq(Base::DEFAULT_TIMEOUT)
          end
        end

        context 'is a number' do
          let(:params) { base_valid_params.merge(timeout: 1) }

          it 'successfully sets the timeout' do
            expect(client.timeout).to eq(params[:timeout])
          end
        end
      end
    end

    context 'client requests from the base class' do
      class FakeClient < Base
        def fake
          get('/fake', {})
        end
      end

      let(:client) { FakeClient.new({ default_params: { developerkey: '123' } }) }

      context 'successful request' do
        before do
          stub_request(:get, %r{https://api.careerbuilder.com/fake.*})
            .to_return(status: 200, body: '{}',
                       headers: { 'content-type' => ['application/json; charset=utf-8'] })
        end

        it { expect(client.fake.success?).to eq(true) }
        it { expect(client.fake.parsed_response).to eq({}) }
      end

      context 'failed request' do
        context 'with a 500' do
          before do
            stub_request(:get, %r{https://api.careerbuilder.com/fake.*})
              .to_return(status: 500, body: '{}',
                         headers: { 'content-type' => ['application/json; charset=utf-8'] })
          end

          it { expect(client.fake.success?).to eq(false) }
          it { expect(client.fake.parsed_response).to eq({}) }
        end

        context 'with a timeout' do
          before do
            stub_request(:get, %r{https://api.careerbuilder.com/fake.*}).to_timeout
          end

          it { expect { client.fake }.to raise_error(Timeout::Error) }
        end
      end

      context 'notifies observers' do
      end
    end
  end
end
