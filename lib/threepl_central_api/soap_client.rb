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

    private

    def default_options
      {
        wsdl: 'https://secure-wms.com/webserviceexternal/contracts.asmx?wsdl',
        log: false,
        raise_errors: false,
        no_message_tag: true
      }
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
