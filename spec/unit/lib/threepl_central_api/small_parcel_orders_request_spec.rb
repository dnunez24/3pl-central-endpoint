require 'spec_helper'

RSpec.describe ThreePLCentralAPI::SmallParcelOrdersRequest do
  context 'when created' do
    it 'sets the default API client to a SOAP client' do
      request = ThreePLCentralAPI::SmallParcelOrdersRequest.new
      expect(request.client).to be_a ThreePLCentralAPI::SOAPClient
    end

    it 'can use a custom API client' do
      client = double('FakeClient')
      request = ThreePLCentralAPI::SmallParcelOrdersRequest.new client: client
      expect(request.client).to equal client
    end
  end

  describe '#dispatch' do
    context 'when successful' do
      it 'returns an API response object' do
        client = double('Client')
        allow(client).to receive(:call)
          .with(:small_parcel_orders, one: 1, two: 2)
          .and_return(small_parcel_orders: ['...', '...'])

        request = ThreePLCentralAPI::SmallParcelOrdersRequest.new client: client
        response = request.dispatch(one: 1, two: 2)
        expect(response).to be_a ThreePLCentralAPI::SmallParcelOrdersResponse
      end
    end

    context 'when failed' do
      it 'allows the API client error to bubble up' do
        client = double('Client')
        allow(client).to receive(:call)
          .with(:small_parcel_orders, one: 1, two: 2)
          .and_raise(ThreePLCentralAPI::Error)

        request = ThreePLCentralAPI::SmallParcelOrdersRequest.new client: client
        expect do
          request.dispatch(one: 1, two: 2)
        end.to raise_exception ThreePLCentralAPI::Error
      end
    end
  end
end
