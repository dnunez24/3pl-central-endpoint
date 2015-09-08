module ThreePLCentralAPI
  class SmallParcelOrdersResponse
    attr_reader :data

    def initialize(response_body)
      @data = []
      extract_shipments response_body
    end

    private

    def extract_shipments(response_body)
      shipments = parse_response_body(response_body)

      shipments.each do |shipment|
        @data << extract_shipment(shipment)
      end
    end

    def extract_shipment(shipment)
      Data::Shipment.new shipment
    end

    def parse_response_body(response_body)
      response = response_body[:small_parcel_orders_response]
      result = response[:small_parcel_orders_result]
      result[:small_parcel]
    end
  end
end
