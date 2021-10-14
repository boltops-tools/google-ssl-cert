class GoogleSslCert::CLI
  class Secret < GoogleSslCert::Command
    desc "save", "Save secret value"
    long_desc Help.text("secret/save")
    def save(name, value)
      GoogleSslCert::Secret.new(options).save(name, value)
    end

    desc "get", "Get secret value"
    def get(name)
      value = GoogleSslCert::Secret.new(options).get(name)
      puts "Secret name: #{name} value #{value}"
    end
  end
end
