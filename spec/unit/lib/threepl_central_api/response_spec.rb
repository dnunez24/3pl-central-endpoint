require 'spec_helper'
require 'savon/mock/spec_helper'

RSpec.describe ThreePLCentralAPI::Response do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '#body' do
    it 'returns a hash containing the SOAP body' do
      skip
      soap_body_hash = {one: 1, two: 2, three: 3}
      response = ThreePLCentralAPI::Response.new body: soap_body_hash
      expect(response.body).to eq soap_hash
    end
  end

  describe '#status' do

  end

  describe '#headers' do

  end
end
