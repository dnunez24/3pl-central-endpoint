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
      handle_response proxy.call(action, message: msg)
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

    def handle_response(response)
      if response.success?
        ThreePLCentralAPI::Response.new
      else
        handle_error(response)
      end
    end

    def handle_error(response)
      soap_fault = response.soap_fault
      http_error = response.http_error

      error = soap_fault || http_error
      fail ThreePLCentralAPI::Error, error.message
    end
  end
end
