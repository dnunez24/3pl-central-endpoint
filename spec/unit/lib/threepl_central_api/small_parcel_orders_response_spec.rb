require 'spec_helper'

RSpec.describe ThreePLCentralAPI::SmallParcelOrdersResponse do
  context 'when created' do
    it 'parses the API response body' do
      body = {
        small_parcel_orders_response: {
          small_parcel_orders_result: {
            small_parcel: [
              { one: 1 },
              { two: 2 }
            ]
          }
        }
      }
      response = ThreePLCentralAPI::SmallParcelOrdersResponse.new body
      expect(response.data).to eq [
        Data::Shipment.new,
        Data::Shipment.new
      ]
    end
  end

  context 'with one shipment' do

  end

  context 'with multiple shipments' do

  end
end
