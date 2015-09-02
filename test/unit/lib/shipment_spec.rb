require 'spec_helper'

RSpec.describe Shipment do
  context 'during initialization' do
    context 'when provided 3PL Central data as an argument' do
      it 'creates a Wombat shipment data object from 3PL Central data' do
        skip
      end
    end
  end

  describe '#add_address' do
    it 'adds an address to the shipment' do
      skip
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

      # wombat_address = {
      #   firstname: 'Jane P.',
      #   lastname: 'Roe',
      #   address1: '5555 NE Some Pl',
      #   address2: nil,
      #   zipcode: '99999',
      #   city: 'Somewhere',
      #   state: 'ID',
      #   country: 'US',
      #   phone: '555-666-7777'
      # }
      #
      # shipment = Shipment.new
      # shipment.add_address(threepl_central_address)
      # expect(shipment.address).to eq wombat_address
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
