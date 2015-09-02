require 'sinatra'
require 'endpoint_base'
require 'json'
require 'threepl_central_api'
require 'shipment'

class ThreePLCentralEndpoint < EndpointBase::Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  # error Savon::SOAPFault do
  #   logger.warn env['sinatra.error'].inspect
  #   result 500, "SOAP Fault: #{env['sinatra.error'].message}"
  # end
  #
  # error Savon::HTTPError do
  #   logger.warn env['sinatra.error'].inspect
  #   result 500, "HTTP Error: #{env['sinatra.error'].message}"
  # end

  error do
    logger.warn env['sinatra.error'].inspect
    result 500, env['sinatra.error'].to_s
  end

  post '/get_shipments' do
    # @client ||= Savon.client(wsdl: @config[:wsdl], log: true, no_message_tag: true)

    msg = {
      'userLoginData' => {
        # 'ThreePLKey' => @config[:threepl_key],
        'ThreePLID' => @config[:threepl_id],
        'Login' => @config[:login],
        'Password' => @config[:password],
        # 'FacilityID' => @config[:facility_id],
        # 'CustomerID' => @config[:customer_id]
      },
      'focr' => {
        'CustomerID' => @config[:customer_id],
        'FacilityID' => @config[:facility_id],
        'RetailerID' => @config[:retailer_id],
        'OverAlloc' => 'Any',
        'ASNSent' => 'Any',
        'RouteSent' => 'Any',
        'Closed' => 'IncludeOnly',
        'BeginDate' => @config[:since],
        'DateRangeType' => 'Confirm',
        'AddressStatus' => 'Any'
      },
      'limitCount' => 10
    }

    response = @client.call(:small_parcel_orders, message: msg, message_tag: nil)
    # parser = Nori.new
    # Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
    # shipments = parser.parse(response.body[:find_orders])['orders']['order']
    shipments = response.body[:small_parcel_orders_result][:small_parcel]

    shipments.each do |shipment|
      logger.info shipment

      carrier = shipment[:warehouse_transaction][:shipping_instructions][:carrier]
      ship_service = shipment[:warehouse_transaction][:shipping_instructions][:ship_service]
      ship_method = "#{carrier} #{ship_service}"
      # TODO map the shipping methods to standard codes
      # @params[:shipping_method_map][ship_method]
      ship_to = shipment[:warehouse_transaction][:ship_to]

      if retailer = shipment[:retailer]
        retailer_name = retailer[:description]
      end

      obj = {
        id: shipment[:warehouse_transaction][:warehouse_transaction_id],
        order_id: shipment[:warehouse_transaction][:trans_info][:reference_num],
        email: ship_to[:email_address1],
        cost: shipment[:warehouse_transaction][:cost_info][:freight_pp],
        status: shipment[:warehouse_transaction][:status],
        stock_location: shipment[:facility][:code],
        shipping_method: ship_method,
        tracking: shipment[:warehouse_transaction][:tracking_info][:tracking_number],
        updated_at: shipment[:warehouse_transaction][:last_modified_date],
        shipped_at: shipment[:warehouse_transaction][:tracking_info][:pickup_date],
        retailer: retailer_name,
        shipping_address: {
          firstname: ship_to[:name],
          lastname: ship_to[:name],
          address1: ship_to[:address][:address1],
          address2: ship_to[:address][:address2],
          zipcode: ship_to[:address][:zip],
          city: ship_to[:address][:city],
          state: ship_to[:address][:state],
          country: ship_to[:address][:country],
          phone: ship_to[:phone_number1]
        }
      }

      obj[:packages] = []

      shipment[:packages][:package].each do |package|
        content = package[:package_contents][:package_content]

        obj[:packages] << {
          tracking_number: package[:tracking_number],
          sku: content[:sku],
          quantity: content[:qty],
          cost: content[:cost]
        }
      end

      obj[:items] = []

      shipment[:order_item][:small_parcel_order_item].each do |item|
        obj[:items] << {
          product_id: item[:sku],
          name: item[:item_description],
          quantity: item[:qty],
          price: item[:price]
        }
      end

      add_object 'shipment', obj
    end

    msg = if (count = shipments.count) > 0
            "Updating #{count} #{'shipment'.pluralize count} from 3PL Central"
          else
            'No shipments found matching import criteria'
          end

    add_parameter 'since', Time.now.utc.iso8601
    result 200, msg
  end
end
