module GoogleSslCert
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "create", "Create Google SSL Certificate and save to Secrets Manager"
    long_desc Help.text(:create)
    option :private_key, desc: "private key path"
    option :certificate, desc: "certificate path"
    option :save_secret, type: :boolean, default: true, desc: "whether or not to save to Google Secrets Manager"
    option :secret_name, desc: "Secret name, conventionally matches the cert name"
    option :extra_certs, desc: "Additional certs to be added to the secret value"
    def create(name=nil)
      Create.new(options.merge(name: name)).run
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
