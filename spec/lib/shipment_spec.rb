require File.expand_path('../../../lib/shipment.rb', __FILE__)

describe Shipment do
  context 'during initialization' do
    context 'when provided 3PL Central data as an argument' do
      it 'creates a Wombat shipment data object from 3PL Central data' do
        response_file = File.expand_path('../../fixtures/small-parcel-orders-response.json', __FILE__)
        response_json = File.open(response_file)
        response = JSON.parse(response_json)
        shipment = response[:small_parcel_orders_result][:small_parcel]

        wombat_obj = {

        }
      end
    end
  end

  describe '#add_address' do
    it 'does something' do
      threepl_central_address = response[:ship_to]

      # threepl_central_address = {
      #   contact_id: '9001',
      #   name: 'Jane P. Roe',
      #   title: nil,
      #   company_name: 'Somecorp',
      #   address: {
      #     address1: '5555 NE Some Pl',
      #     address2: nil,
      #     city: 'Somewhere',
      #     state: 'ID',
      #     zip: '99999',
      #     country: 'US'
      #   },
      #   phone_number1: '555-666-7777',
      #   fax: nil,
      #   email_address1: nil,
      #   retailer_id: '0',
      #   dept: nil,
      #   is_ship_to_quick_lookup: true,
      #   contact_type: 'ShipTo',
      #   code: 'Primary',
      #   customer_id: '0',
      #   bill3rd_party_account: nil,
      #   address_status: 'Any'
      # }

      wombat_address = {
        firstname: 'Jane P.',
        lastname: 'Roe',
        address1: '5555 NE Some Pl',
        address2: nil,
        zipcode: '99999',
        city: 'Somewhere',
        state: 'ID',
        country: 'US',
        phone: '555-666-7777'
      }

      shipment = Shipment.new
      shipment.add_address(threepl_central_address)
      expect(shipment.address).to eq wombat_address
    end
  end

  describe '#add_packages' do

  end

  describe '#add_package' do

  end

  describe '#add_items' do

  end

  describe '#add_item' do

  end
end
