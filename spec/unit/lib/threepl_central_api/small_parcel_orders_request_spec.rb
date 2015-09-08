require 'spec_helper'

RSpec.describe ThreePLCentralAPI::SmallParcelOrdersRequest do
  context 'when created' do
    it 'sets the default API client to a SOAP client' do
      client_class = ThreePLCentralAPI::SOAPClient
      request = ThreePLCentralAPI::SmallParcelOrdersRequest.new
      expect(request.client).to be_a client_class
    end

    it 'sets the default API response class' do
      default_response_class = ThreePLCentralAPI::SmallParcelOrdersResponse
      request = ThreePLCentralAPI::SmallParcelOrdersRequest.new
      expect(request.response_class).to eq default_response_class
    end

    it 'can use a custom API client' do
      client = double('FakeClient')
      request = ThreePLCentralAPI::SmallParcelOrdersRequest.new client: client
      expect(request.client).to equal client
    end

    it 'can use a custom response class' do
      response_class = class_double('Response')
      request = ThreePLCentralAPI::SmallParcelOrdersRequest.new(
        response_class: response_class
      )
      expect(request.response_class).to equal response_class
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
