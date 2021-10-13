class GoogleSslCert::CLI
  class Create
    include GoogleSslCert::GoogleServices
    extend Memoist

    def initialize(options={})
      @options = options
      @name = options[:name] || generate_name
      @private_key = private_key
      @certificate = certificate
    end

    def run
      check!
      create_cert
    end

    def create_cert
      ssl_certificates.insert(
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

    def check!
      error = []
      unless @private_key
        error << "None of the private keys could be found: #{private_keys.join(' ')}"
      end
      unless @certificate
        error << "None of the certificates could be found: #{certificates.join(' ')}"
      end
      unless error.empty?
        $stderr.puts error
        $stderr.puts <<~EOL
          Are you sure that:

              * You're in the right directory with the cert files?
              * Or have specified the right path?
        EOL
        exit
      end
    end

    def private_key
      find_file(private_keys)
    end

    def private_keys
      [@options[:private_key], "server.key", "key.pem"].compact
    end

    # signed cert
    def certificate
      find_file(certificates)
    end

    def certificates
      [@options[:certificate], "server.crt", "cert.pem"].compact
    end

    def find_file(*paths)
      paths.flatten.find do |path|
        File.exist?(path)
      end
    end
  end
end
