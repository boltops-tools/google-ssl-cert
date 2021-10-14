module GoogleSslCert
  class Base
    include GoogleServices
    include Logging
    include Helpers::Global
    include Helpers::ProjectNumber
    extend Memoist

    def initialize(options={})
      @options = options
    end
  end
end

