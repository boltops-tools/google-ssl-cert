module GoogleSslCert
  class Name
    attr_reader :base_name
    def initialize(options={})
      @options = options
      @base_name = @options[:cert_name] || default_cert_name
    end

    def generate
      ts = Time.now.strftime("%Y%m%d%H%M%S") unless @options[:timestamp] == false # nil defaults to true
      [@base_name, ts].compact.join('-')
    end

    def default_cert_name
      type = @options[:global] ? "global" : ENV['GOOGLE_REGION']
      ["google-ssl-cert", type].join('-')
    end
  end
end
