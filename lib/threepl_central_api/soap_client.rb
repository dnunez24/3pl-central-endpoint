require 'savon'

module ThreePLCentralAPI
  class SOAPClient
    def call(action, **msg)
      proxy.call(action, message: msg)
    end

    def proxy
      @proxy ||= Savon.client(wsdl: wsdl, log: enable_logging, no_message_tag: true)
    end

    def wsdl
      @wsdl ||= 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl'
    end

    def enable_logging
      @enable_loggin ||= false
    end
  end
end
