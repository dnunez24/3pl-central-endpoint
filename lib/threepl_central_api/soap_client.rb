require 'savon'

module ThreePLCentralAPI
  class SOAPClient
    attr_reader :wsdl, :enable_logging, :raise_errors

    def initialize(**opts)
      options = default_options.merge(opts)
      @wsdl = options[:wsdl]
      @enable_logging = options[:enable_logging]
      @raise_errors = options[:raise_errors]
    end

    def call(action, **msg)
      @response = proxy.call(action, message: msg)
      handle_response
    end

    private

    def default_options
      {
        wsdl: 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl',
        enable_logging: false,
        raise_errors: false
      }
    end

    def proxy
      @proxy ||= Savon.client(
        wsdl: wsdl,
        log: enable_logging,
        raise_errors: raise_errors,
        no_message_tag: true
      )
    end

    def handle_response
      if @response.success?
        response_body
      else
        handle_error
      end
    end

    def handle_error
      error = response_soap_fault || response_http_error
      fail ThreePLCentralAPI::Error, error.message
    end

    def response_body
      @response.body
    end

    def response_http_error
      @response.http_error
    end

    def response_soap_fault
      @response.soap_fault
    end
  end
end
