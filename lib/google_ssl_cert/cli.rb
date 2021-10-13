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
    def create(name=nil)
      Create.new(options.merge(name: name)).run
    end

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
