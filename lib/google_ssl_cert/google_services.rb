require "google-cloud-resource_manager"
require "google-cloud-secret_manager"
require "google/cloud/compute/v1/region_ssl_certificates"
require "google/cloud/compute/v1/ssl_certificates"

module GoogleSslCert
  module GoogleServices
    extend Memoist

    def region_ssl_certificates
      Google::Cloud::Compute::V1::RegionSslCertificates::Rest::Client.new
    end
    memoize :region_ssl_certificates

    def secret_manager_service
      Google::Cloud::SecretManager.secret_manager_service
    end
    memoize :secret_manager_service

    def ssl_certificates
      Google::Cloud::Compute::V1::SslCertificates::Rest::Client.new
    end
    memoize :ssl_certificates

    def resource_manager
      Google::Cloud.new.resource_manager
    end
    memoize :resource_manager
  end
end
