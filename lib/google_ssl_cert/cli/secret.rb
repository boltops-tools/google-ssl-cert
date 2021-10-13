class GoogleSslCert::CLI
  class Secret < GoogleSslCert::Command
    desc "save", "Save secret value"
    long_desc Help.text("secret/save")
    def save(name, value)
      GoogleSslCert::Secret.new(options).save(name, value)
    end

    desc "get", "Get secret value"
    def get(name)
      GoogleSslCert::Secret.new(options).get(name)
    end
  end
end
