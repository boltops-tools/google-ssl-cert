class GoogleSslCert::CLI
  class Base
    include GoogleSslCert::GoogleServices
    include GoogleSslCert::Helpers::Global
    include GoogleSslCert::Logging
    extend Memoist

    def initialize(options={})
      @options = options
    end
  end
end
