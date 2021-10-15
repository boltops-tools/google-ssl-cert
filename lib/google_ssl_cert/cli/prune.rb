class GoogleSslCert::CLI
  class Prune < Base
    include GoogleSslCert::Helpers::ProjectNumber

    def run
      keep = @options[:keep] || 1
      right = -1 - keep
      certs = ssl_certs[0..right] || [] # delete all except the last cert

      if certs.empty?
        logger.info "No timestamped certs to prune with cert name: #{cert_base_name}"
        return
      end

      preview_delete(certs) unless @options[:yes]
      sure?
      perform_delete(certs)
    end

    def preview_delete(certs)
      logger.info "Will delete the following #{type} certs:"
      certs.each do |cert|
        logger.info "  #{cert.name}"
      end
    end

    def perform_delete(certs)
      certs.each do |cert|
        delete(cert)
      end
    end

    def delete(cert)
      options = base_options.merge(ssl_certificate: cert.name)
      ssl_service.delete(options)
      logger.info "Deleted #{type} cert: #{cert.name}"
    end

    def type
      global? ? "global" : "region"
    end

    # sadly the filter option doesnt support globs or regexp so will have to filter with ruby
    def ssl_certs
      resp = ssl_service.list(base_options)
      resp.select do |ssl|
        match?(ssl.name)
      end.sort_by(&:name)
    end

    def match?(name)
      !!(name =~ Regexp.new("^#{cert_base_name}-\\d{14}$"))
    end

    def cert_base_name
      @cert_base_name = GoogleSslCert::Name.new(@options).base_name
    end

    def ssl_service
      if global?
        ssl_certificates
      else
        region_ssl_certificates
      end
    end

    def base_options
      options = { project: ENV['GOOGLE_PROJECT'] }
      options[:region] = ENV['GOOGLE_REGION'] unless global?
      options
    end

  private
    def sure?(message="Are you sure?")
      if @options[:yes]
        sure = 'y'
      else
        print "#{message} (y/N) "
        sure = $stdin.gets
      end

      unless sure =~ /^y/
        puts "Whew! Exiting."
        exit 0
      end
    end
  end
end
