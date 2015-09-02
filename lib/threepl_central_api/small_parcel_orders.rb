module ThreePLCentralAPI
  class SmallParcelOrders
    def initialize(client: nil)
      @client = client unless client.nil?
    end

    def client
      @client ||= ThreePLCentralAPI::SOAPClient.new
    end

    def call(**args)
      client.call(:small_parcel_orders, **args)
    end
  end
end
