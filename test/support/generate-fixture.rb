#!/usr/bin/env ruby

require 'savon'
require 'json'


class ResponseGenerator
  def initialize(client: nil)
    @client = client unless client.nil?
  end

  def generate(action, **args)
    send(action.to_sym, **args)
  end

  def small_parcel_orders(args)
    msg = {
      'userLoginData' => {
        'ThreePLID' => ENV['3PL_CENTRAL_ID'],
        'Login' => ENV['3PL_CENTRAL_LOGIN'],
        'Password' => ENV['3PL_CENTRAL_PASSWORD']
      },
      'focr' => {
        'CustomerID' => args[:customer_id],
        'FacilityID' => args[:facility_id],
        'OverAlloc' => 'Any',
        'ASNSent' => 'Any',
        'RouteSent' => 'Any',
        'Closed' => 'IncludeOnly',
        'BeginDate' => DateTime.parse(args[:start_date]).iso8601,
        'DateRangeType' => 'Confirm',
        'AddressStatus' => 'Any'
      },
      'limitCount' => 2
    }

    response = client.call(:small_parcel_orders, message: msg, message_tag: nil)
    write_response(response)
  end

  def write_response(response)
    response_file = File.expand_path('../../fixtures/small-parcel-orders-response.json', __FILE__)

    File.open(response_file, 'w') do |file|
      file << JSON.pretty_generate(response.body)
    end
  end

  def client
    @client ||= Savon.client(wsdl: wsdl, log: true, no_message_tag: true)
  end

  def wsdl
    @wsdl ||= 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl'
  end
end

action, customer_id, facility_id, start_date = ARGV
generator = ResponseGenerator.new
generator.generate(
  action,
  customer_id: customer_id,
  facility_id: facility_id,
  start_date: start_date
)
