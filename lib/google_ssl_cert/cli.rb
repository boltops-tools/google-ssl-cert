module GoogleSslCert
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    secret_name_option = Proc.new do
      option :secret_name, desc: "Secret name, conventionally matches the cert name"
    end
    global_option = Proc.new do
      option :global, type: :boolean, default: true, desc: "Flag to create global vs region cert"
    end
    cert_name_option = Proc.new do
      option :cert_name, desc: "Google SSL Cert name"
    end

    desc "create", "Create Google SSL Certificate and save to Secrets Manager"
    long_desc Help.text(:create)
    option :private_key, desc: "private key path"
    option :certificate, desc: "certificate path"
    option :save_secret, type: :boolean, default: true, desc: "whether or not to save to Google Secrets Manager"
    option :extra_certs, desc: "Additional certs to be added to the secret value"
    option :timestamp, type: :boolean, default: true, desc: "Auto-append timestamp to cert name. Appending a timestamp allows auto-pruning also"
    option :prune, type: :boolean, default: true, desc: "Auto-prune old certs based on timestamp"
    cert_name_option.call
    secret_name_option.call
    global_option.call
    def create
      Create.new(options).run
    end

    desc "prune", "prune Google SSL Certificate and save to Secrets Manager"
    long_desc Help.text(:prune)
    cert_name_option.call
    global_option.call
    option :yes, aliases: %w[y], type: :boolean, desc: "Skip 'are you sure' prompt"
    option :keep, type: :numeric, default: 1, desc: "Number of certs to keep"
    def prune
      Prune.new(options).run
    end

    desc "secret SUBCOMMAND", "secret subcommands"
    long_desc Help.text(:secret)
    subcommand "secret", Secret

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text(:completion)
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text(:completion_script)
    def completion_script
      Completer::Script.generate
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
