require 'savon'

module ThreePLCentralAPI
  class SOAPClient
    def initialize(**opts)
      @options = options.merge(opts) unless opts.empty?
    end

    def call(action, **msg)
      handle_response proxy.call(action, message: msg)
    end

    def proxy
      @proxy ||= Savon.client(options)
    end

    def options
      @options ||= default_options
    end

    def wsdl
      @wsdl ||= 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl'
    end

    def enable_logging
      @enable_logging ||= false
    end

    def raise_errors
      @raise_errors ||= false
    end

    def default_options
      {
        wsdl: wsdl,
        log: enable_logging,
        raise_errors: raise_errors,
        no_message_tag: true
      }
    end

    private

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
