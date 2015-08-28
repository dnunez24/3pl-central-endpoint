module ThreePLCentralAPI
  class SOAPClient
    def initialize(wsdl)
      @wsdl = wsdl
    end

    def call(action, msg)
      response = proxy.call(action, message: msg)
      response.body
    end

    def proxy
      @proxy ||= Savon.client(wsdl: @wsdl, log: true, no_message_tag: true)
    end
  end
end
