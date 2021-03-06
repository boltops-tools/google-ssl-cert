# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "google_ssl_cert/version"

Gem::Specification.new do |spec|
  spec.name          = "google-ssl-cert"
  spec.version       = GoogleSslCert::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.summary       = "Google SSL Cert Tool"
  spec.homepage      = "https://github.com/boltops-tools/google-ssl-cert"
  spec.license       = "Apache-2.0"

  spec.files         = File.directory?('.git') ? `git ls-files`.split($/) : Dir.glob("**/*")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "google-cloud-compute-v1"
  spec.add_dependency "google-cloud-resource_manager"
  spec.add_dependency "google-cloud-secret_manager"
  spec.add_dependency "memoist"
  spec.add_dependency "rainbow"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "cli_markdown"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end
end
