module GoogleSslCert
  module Logging
    extend Memoist

    def logger
      $logger ||= Logger.new($stderr)
    end
  end
end
