class GoogleSslCert::CLI
  class Create < Base
    def initialize(options={})
      super
      @cert_name = GoogleSslCert::Name.new(@options)
      @secret_name  = @options[:secret_name] || @cert_name.base_name
    end

    def run
      validate!
      create_cert
      save_secret if @options[:save_secret]
    end

    # Google API Docs:
    #    https://cloud.google.com/compute/docs/reference/rest/v1/sslCertificates/insert
    def create_cert
      GoogleSslCert::Cert.new(@options.merge(cert_name: @cert_name.generated_name)).create
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
      secret_value = @cert_name.generated_name # @cert_name the value because it will be referenced. the @cert_name or 'key' will be the same
      secret.save(@secret_name, secret_value)
    end

    def secret
      GoogleSslCert::Secret.new(@options)
    end
    memoize :secret

  private
    def validate!
      errors = []
      unless ENV['GOOGLE_APPLICATION_CREDENTIALS']
        errors << "ERROR: The GOOGLE_APPLICATION_CREDENTIALS env var must be set."
      end
      unless ENV['GOOGLE_PROJECT']
        errors << "ERROR: The GOOGLE_PROJECT env var must be set."
      end
      if !ENV['GOOGLE_REGION'] and !global?
        errors << "ERROR: The GOOGLE_REGION env var must be when creating a region cert."
      end

      # extra validation early to prevent google ssl cert name error
      #   An error has occurred when making a REST request: Invalid value for field 'resource.name': 'cert_app1-global-20211031234501'. Must be a match of regex '(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)' (Google::Cloud::InvalidArgumentError)
      if @secret_name !~ /^[a-zA-Z\-0-9]+$/ # no underscore allowed
        errors << "ERROR: CERT_NAME invalid format. Expected format: [a-zA-Z0-9]+" # Expected format taken from `gcloud secrets create`
      end

      unless errors.empty?
        logger.error errors.join("\n")
        exit 1
      end
    end
  end
end
