class GoogleSslCert::CLI
  class Create
    include GoogleSslCert::GoogleServices
    include GoogleSslCert::Logging
    extend Memoist

    def initialize(options={})
      @options = options
      @cert_name = options[:cert_name] || generate_name
      @private_key = private_key
      @certificate = certificate
    end

    def run
      check!
      create_cert
      save_secret if @options[:save_secret]
    end

    def create_cert
      ssl_certificates.insert(
        project: ENV['GOOGLE_PROJECT'],
        ssl_certificate_resource: {
          name: @cert_name,
          private_key: IO.read(@private_key),
          certificate: IO.read(@certificate),
        }
      )
      puts "Google SSL Cert Created: #{@cert_name}"
    rescue Google::Cloud::AlreadyExistsError => e
      logger.error "#{e.class}: #{e.message}"
    end

    # The secret name is expected to be static/predictable
    # The secret value is the changed/updated google ssl cert
    #
    # Example:
    #   secret_name  = demo_ssl-cert-name
    #   secret_value = google-ssl-cert-20211013231005
    #
    #   gcloud compute ssl-certificates list
    #   NAME                            TYPE          CREATION_TIMESTAMP             EXPIRE_TIME                    MANAGED_STATUS
    #   google-ssl-cert-20211013231005  SELF_MANAGED  2021-10-13T16:10:05.795-07:00  2022-10-12T17:22:01.000-07:00
    #   gcloud secrets list
    #   NAME                CREATED              REPLICATION_POLICY  LOCATIONS
    #   demo_ssl-cert-name  2021-10-13T23:10:06  automatic
    #
    def save_secret
      secret_value = @cert_name # @cert_name the value because it will be referenced. the @cert_name or 'key' will be the same
      secret_name  = @options[:secret_name]
      GoogleSslCert::Secret.new(@options).save(secret_name, secret_value)
    end

  private
    def generate_name
      "google-ssl-cert-#{Time.now.strftime("%Y%m%d%H%M%S")}"
    end
    memoize :generate_name

    def check!
      error = []
      unless @private_key
        error << "None of the private keys could be found: #{private_keys.join(' ')}"
      end
      unless @certificate
        error << "None of the certificates could be found: #{certificates.join(' ')}"
      end
      unless error.empty?
        logger.error error
        logger.error <<~EOL
          Are you sure that:

              * You're in the right directory with the cert files?
              * Or have specified the right path?
        EOL
        exit
      end

      secret_name = @options[:secret_name]
      if @options[:save_secret] && !secret_name
        error << "--secret-name must be provided or --no-save-secret option must be used"
      end
      # extra validation early to prevent google ssl cert from being created but the secret not being stored
      if secret_name && secret_name !~ /^[a-zA-Z_\-0-9]+$/
        error << "--secret-name invalid format. Expected format: [a-zA-Z_0-9]+" # Expected format taken from `gcloud secrets create`
      end
      unless error.empty?
        puts error
        exit
      end
    end

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
  end
end
