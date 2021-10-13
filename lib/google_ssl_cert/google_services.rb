module GoogleSslCert
  module GoogleServices
    extend Memoist

    def ssl_certificates
      Google::Cloud::Compute::V1::SslCertificates::Rest::Client.new
    end
    memoize :ssl_certificates
  end
end
