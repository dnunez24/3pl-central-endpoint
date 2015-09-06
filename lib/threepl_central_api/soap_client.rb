require 'savon'

module ThreePLCentralAPI
  class SOAPClient
    def initialize(**opts)
      @options = options.merge(opts) unless opts.empty?
    end

    def call(action, **msg)
      handle_response proxy.call(action, message: msg)
    end

    def options
      @options ||= default_options
    end

    def wsdl
      options[:wsdl]
    end

    def enable_logging
      options[:enable_logging]
    end

    def raise_errors
      options[:raise_errors]
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
