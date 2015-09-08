require 'spec_helper'

RSpec.describe ThreePLCentralAPI::SmallParcelOrdersRequest do
  context 'when created with no arguments' do
    it 'sets a default SOAP client' do
      skip
      api = ThreePLCentralAPI::SmallParcelOrdersRequest.new
      expect(api.client).to be_a ThreePLCentralAPI::SOAPClient
    end
  end

  context 'when created with a custom client' do
    it 'sets a custom client' do
      skip
      client = double('Client')
      api = ThreePLCentralAPI::SmallParcelOrdersRequest.new client: client
      expect(api.client).to eq client
    end
  end

  describe '#call' do
    it 'returns a response from the SOAP client call' do
      skip
      client = instance_double('SOAPClient')
      response = { small_parcel_orders_response: '...' }
      allow(client).to receive(:call) { response }

      api = ThreePLCentralAPI::SmallParcelOrdersRequest.new client: client
      args = { one: 1, two: 2, three: 3 }
      expect(api.call(args)).to be_a ThreePLCentralAPI::SmallParcelOrdersResponse
    end
  end
end
