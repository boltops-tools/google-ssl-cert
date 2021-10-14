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

      if global?
        ssl_certificates.insert(
          project: ENV['GOOGLE_PROJECT'],
          ssl_certificate_resource: ssl_certificate_resource,
        )
        logger.info "Global cert created: #{@cert_name}"
      else
        region_ssl_certificates.insert(
          project: ENV['GOOGLE_PROJECT'],
          region: region,
          ssl_certificate_resource: ssl_certificate_resource,
        )
        logger.info "Region cert created: #{@cert_name} in region: #{region}"
      end
    rescue Google::Cloud::AlreadyExistsError => e
      logger.error "#{e.class}: #{e.message}"
    end

  private
    def private_key
      find_file(private_keys)
    end

    def private_keys
      [@options[:private_key], "private.key", "server.key", "key.pem"].compact
    end

    # signed cert
    def certificate
      find_file(certificates)
    end

    def certificates
      [@options[:certificate], "certificate.crt", "server.crt", "cert.pem"].compact
    end

    def find_file(*paths)
      paths.flatten.find do |path|
        File.exist?(path)
      end
    end

    def validate!
      errors = []
      unless @private_key
        errors << "ERROR: None of the private keys could be found: #{private_keys.join(' ')}"
      end
      unless @certificate
        errors << "ERROR: None of the certificates could be found: #{certificates.join(' ')}"
      end
      unless errors.empty?
        logger.error errors.join("\n")
        logger.error <<~EOL

          Are you sure that:

              * You're in the right directory with the cert files?
              * Or can specify the path to the cert files with options:
              * --certificate and --private-key
        EOL
        exit 1
      end
    end
  end
end
