module ThreePLCentralAPI
  class SmallParcelOrdersRequest
    attr_reader :client, :response_class

    def initialize(client: nil, response_class: nil)
      @client = client || default_client
      @response_class = response_class || default_response_class
    end

    def dispatch(msg)
      receive client.call(action, msg)
    end

    def receive(response)
      response_class.new(response)
    end

    private

    def action
      :small_parcel_orders
    end

    def default_client
      ThreePLCentralAPI::SOAPClient.new
    end

    def default_response_class
      ThreePLCentralAPI::SmallParcelOrdersResponse
    end
  end
end
