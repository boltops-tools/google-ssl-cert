$stdout.sync = true unless ENV["GOOGLE_SSL_CERT_STDOUT_SYNC"] == "0"

$:.unshift(File.expand_path("../", __FILE__))

require "google_ssl_cert/autoloader"
GoogleSslCert::Autoloader.setup

require "memoist"
require "rainbow/ext/string"

require "google/cloud/compute/v1/ssl_certificates"

module GoogleSslCert
  class Error < StandardError; end
end
