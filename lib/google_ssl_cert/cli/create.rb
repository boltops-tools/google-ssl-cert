class GoogleSslCert::CLI
  class Create
    include GoogleSslCert::GoogleServices
    include GoogleSslCert::Logging
    extend Memoist

    def initialize(options={})
      @options = options
      @cert_name = @options[:cert_name] || generate_name
    end

    def run
      create_cert
      save_secret if @options[:save_secret]
    end

    # Google API Docs:
    #    https://cloud.google.com/compute/docs/reference/rest/v1/sslCertificates/insert
    def create_cert
      GoogleSslCert::Cert.new(@options.merge(cert_name: @cert_name)).create
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
      secret_name  = @options[:secret_name]
      secret_value = @cert_name # @cert_name the value because it will be referenced. the @cert_name or 'key' will be the same
      puts "secret_name #{secret_name}"
      puts "secret_value #{secret_value}"
      GoogleSslCert::Secret.new(@options).save(secret_name, secret_value)
    end

  private
    def generate_name
      "google-ssl-cert-#{Time.now.strftime("%Y%m%d%H%M%S")}"
    end
    memoize :generate_name
  end
end
