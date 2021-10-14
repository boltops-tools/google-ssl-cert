module GoogleSslCert::Helpers
  module Global
    def global?
      GoogleSslCert::Global.new(@options).global?
    end
  end
end
