require 'spec_helper'
require 'savon/mock/spec_helper'

RSpec.describe ThreePLCentralAPI::SOAPClient do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  context 'when created' do
    it 'sets default client options' do
      client = ThreePLCentralAPI::SOAPClient.new
      expect(client.options[:wsdl]).to eq 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl'
      expect(client.options[:log]).to be false
      expect(client.options[:raise_errors]).to be false
      expect(client.options[:no_message_tag]).to be true
    end

    it 'allows overriding the default WSDL' do
      client = ThreePLCentralAPI::SOAPClient.new wsdl: 'http://example.com?wsdl'
      expect(client.options[:wsdl]).to eq 'http://example.com?wsdl'
    end

    it 'allows overriding the default log setting' do
      client = ThreePLCentralAPI::SOAPClient.new log: true
      expect(client.options[:log]).to be true
    end

    it 'allows overriding the default error setting' do
      client = ThreePLCentralAPI::SOAPClient.new raise_errors: true
      expect(client.options[:raise_errors]).to be true
    end

    it 'allows overriding the default no message tag setting' do
      client = ThreePLCentralAPI::SOAPClient.new no_message_tag: false
      expect(client.options[:no_message_tag]).to be false
    end
  end

  describe '#call' do
    let(:client) { ThreePLCentralAPI::SOAPClient.new }

    before(:each) do
      savon.expects(:small_parcel_orders)
        .with(message: {one: 1, two: 2})
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
