module GoogleSslCert
  class Name
    extend Memoist

    def initialize(options={})
      @options = options
      @append_type = @options[:append_type].nil? ? true : @options[:append_type]
    end

    def generated_name
      ts = Time.now.strftime("%Y%m%d%H%M%S") unless @options[:timestamp] == false # nil defaults to true
      [base_name, ts].compact.join('-')
    end
    memoize :generated_name

    def base_name
      type = @options[:global] ? "global" : ENV['GOOGLE_REGION'] if @append_type
      [@options[:cert_name], type].compact.join('-')
    end
  end
end
