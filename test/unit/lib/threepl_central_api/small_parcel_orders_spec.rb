require 'spec_helper'

module ThreePLCentralAPI
  RSpec.describe SmallParcelOrders do
    context 'when created with no arguments' do
      it 'sets a default SOAP client' do
        api = ThreePLCentralAPI::SmallParcelOrders.new
        expect(api.client).to be_a SOAPClient
      end
    end

    context 'when created with a custom client' do
      it 'sets a custom client' do
        client = double('Client')
        api = ThreePLCentralAPI::SmallParcelOrders.new client: client
        expect(api.client).to eq client
      end
    end

    describe '#call' do
      it 'returns a response from the SOAP client call' do
        client = instance_double('SOAPClient')
        response = { small_parcel_orders_response: '...' }
        allow(client).to receive(:call) { response }

        api = ThreePLCentralAPI::SmallParcelOrders.new client: client
        args = { one: 1, two: 2, three: 3 }
        expect(api.call(args)).to eq response
      end
    end
  end
end
