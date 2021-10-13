class GoogleSslCert::CLI
  class Create
    include GoogleSslCert::GoogleServices
    extend Memoist

    def initialize(options={})
      @options = options
      @name = options[:name] || generate_name
      @private_key = options[:private_key] || conventional_private_key
      @certificate = options[:certificate] || conventional_certificate
    end

    def run
      create_cert
    end

    def create_cert
      resp = ssl_certificates.insert(
        project: ENV['GOOGLE_PROJECT'],
        ssl_certificate_resource: {
          name: @name,
          private_key: IO.read(@private_key),
          certificate: IO.read(@certificate),
        }
      )
      puts "Google SSL Cert Created: #{@name}"
    rescue Google::Cloud::AlreadyExistsError => e
      $stderr.puts "#{e.class}: #{e.message}"
    end

  private
    def generate_name
      "google-ssl-cert-#{Time.now.strftime("%Y%m%d%H%M%S")}"
    end
    memoize :generate_name

    def conventional_private_key
      find_file("server.key", "key.pem")
    end

    # signed cert
    def conventional_certificate
      find_file("server.crt", "cert.pem")
    end

    def find_file(*paths)
      paths.find do |path|
        File.exist?(path)
      end
    end
  end
end
