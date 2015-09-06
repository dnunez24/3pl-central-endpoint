require 'spec_helper'
require 'savon/mock/spec_helper'

RSpec.describe ThreePLCentralAPI::SOAPClient do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  context 'when created' do
    it 'sets default client options' do
      client = ThreePLCentralAPI::SOAPClient.new
      expect(client.wsdl).to eq 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl'
      expect(client.enable_logging).to eq false
      expect(client.raise_errors).to eq false
    end

    it 'allows overriding the default options' do
      client = ThreePLCentralAPI::SOAPClient.new(
        wsdl: 'http://example.com?wsdl',
        enable_logging: true,
        raise_errors: true
      )
      expect(client.wsdl).to eq 'http://example.com?wsdl'
      expect(client.enable_logging).to eq true
      expect(client.raise_errors).to eq true
    end
  end

  describe '#call' do
    let(:client) { ThreePLCentralAPI::SOAPClient.new }

    before(:each) do
      savon.expects(:small_parcel_orders)
        .with(message: { one: 1, two: 2 })
        .returns(stubbed_response)
    end

    context 'when response is successful' do
      let(:stubbed_response) do
        File.read 'test/fixtures/small_parcel_orders/success/single_order.xml'
      end

      it 'returns an API response' do
        response = client.call(:small_parcel_orders, one: 1, two: 2)
        expect(response).to be_a ThreePLCentralAPI::Response
      end
    end

    context 'when response is a SOAP fault' do
      let(:stubbed_response) do
        File.read 'test/fixtures/small_parcel_orders/failure/bad_param.xml'
      end

      it 'raises an API error' do
        error_msg = /^\(soap:Server\).+Server was unable to process request/
        expect do
          client.call(:small_parcel_orders, one: 1, two: 2)
        end.to raise_error ThreePLCentralAPI::Error, error_msg
      end
    end

    context 'when response is an HTTP error' do
      let(:fixture) do
        File.read 'test/fixtures/http_error.html'
      end

      let(:stubbed_response) do
        { code: 503, headers: {}, body: fixture }
      end

      it 'raises an API error' do
        error_msg = "HTTP error (503): #{fixture}"
        expect do
          client.call(:small_parcel_orders, one: 1, two: 2)
        end.to raise_error ThreePLCentralAPI::Error, error_msg
      end
    end
  end
end
