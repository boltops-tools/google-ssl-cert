module GoogleSslCert
  class Name
    attr_reader :base_name
    def initialize(options={})
      @options = options
      @base_name = @options[:cert_name] || "google-ssl-cert"
    end

    def generate
      ts = Time.now.strftime("%Y%m%d%H%M%S") unless @options[:timestamp] == false # nil defaults to true
      [@base_name, ts].compact.join('-')
    end
  end
end
