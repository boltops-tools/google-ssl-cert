require "google/cloud/compute/v1/ssl_certificates"
require "google-cloud-secret_manager"

module GoogleSslCert
  module GoogleServices
    extend Memoist

    def secret_manager_service
      Google::Cloud::SecretManager.secret_manager_service
    end
    memoize :secret_manager_service

    def ssl_certificates
      Google::Cloud::Compute::V1::SslCertificates::Rest::Client.new
    end
    memoize :ssl_certificates
  end
end
