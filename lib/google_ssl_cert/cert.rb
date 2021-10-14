module GoogleSslCert
  class Cert < Base
    extend Memoist

    def initialize(*)
      super
      @cert_name = @options[:cert_name]
      @private_key = private_key
      @certificate = certificate
    end

    def create
      validate!
      region = ENV['GOOGLE_REGION']
      ssl_certificate_resource = {
        name: @cert_name,
        private_key: IO.read(@private_key),
        certificate: IO.read(@certificate),
      }

      if regional?
        region_ssl_certificates.insert(
          project: ENV['GOOGLE_PROJECT'],
          region: region,
          ssl_certificate_resource: ssl_certificate_resource,
        )
        logger.info "Regional cert created: #{@cert_name} in region: #{region}"
      else
        ssl_certificates.insert(
          project: ENV['GOOGLE_PROJECT'],
          ssl_certificate_resource: ssl_certificate_resource,
        )
        logger.info "Global cert created: #{@cert_name}"
      end
    rescue Google::Cloud::AlreadyExistsError => e
      logger.error "#{e.class}: #{e.message}"
    end

  private
    def private_key
      find_file(private_keys)
    end

    def private_keys
      [@options[:private_key], "server.key", "key.pem"].compact
    end

    # signed cert
    def certificate
      find_file(certificates)
    end

    def certificates
      [@options[:certificate], "server.crt", "cert.pem"].compact
    end

    def find_file(*paths)
      paths.flatten.find do |path|
        File.exist?(path)
      end
    end

    def regional?
      default_region = !%w[0 false].include?(ENV['GSC_REGION']) # nil will default to true
      @options[:region].nil? ? default_region : @options[:region]
    end

    def validate!
      error = []
      unless @private_key
        error << "ERROR: None of the private keys could be found: #{private_keys.join(' ')}"
      end
      unless @certificate
        error << "ERROR: None of the certificates could be found: #{certificates.join(' ')}"
      end
      unless error.empty?
        logger.error error.join("\n")
        logger.error <<~EOL

          Are you sure that:

              * You're in the right directory with the cert files?
              * Or have specified the right path?
        EOL
        exit
      end
    end
  end
end

