module GoogleSslCert
  class Name
    attr_reader :base_name
    def initialize(options={})
      @options = options
      @base_name = @options[:cert_name] || "google-ssl-cert"
    end

    def generate
      "#{@base_name}-#{Time.now.strftime("%Y%m%d%H%M%S")}"
    end
  end
end
