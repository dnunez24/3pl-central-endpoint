require 'spec_helper'
require 'savon/mock/spec_helper'

RSpec.describe ThreePLCentralAPI::SOAPClient do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '#call' do
    it 'returns a web service response' do
      fixture = File.read('test/fixtures/small_parcel_orders/success/single_order.xml')
      savon.expects(:small_parcel_orders).with(message: :any).returns(fixture)

      client = ThreePLCentralAPI::SOAPClient.new
      response = client.call(:small_parcel_orders)
      
      expect(response).to be_a Savon::Response
      expect(response).to be_successful
    end
  end
end
