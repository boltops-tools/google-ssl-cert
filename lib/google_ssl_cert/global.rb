module GoogleSslCert
  class Global
    def initialize(options={})
      @options = options
    end

    def global?
      default_global = !%w[0 false].include?(ENV['GSC_GLOBAL']) # nil will default to true
      @options[:global].nil? ? default_global : @options[:global]
    end
  end
end
