module GoogleSslCert
  class Secret
    def initialize(options={})
      @options = options
    end

    def save(name, value)
      puts "saving name #{name} value #{value}"
    end

    def get(name)
      puts "get name #{name}"
    end
  end
end
