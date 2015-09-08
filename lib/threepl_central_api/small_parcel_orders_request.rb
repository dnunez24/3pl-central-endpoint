module ThreePLCentralAPI
  class SmallParcelOrdersRequest
    attr_reader :client

    def initialize(client: nil)
      @client = client || default_client
    end

    def dispatch(msg)
      receive client.call(action, msg)
    end

    def receive(response)
      ThreePLCentralAPI::SmallParcelOrdersResponse.new(response)
    end

    private

    def action
      :small_parcel_orders
    end

    def default_client
      ThreePLCentralAPI::SOAPClient.new
    end
  end
end
