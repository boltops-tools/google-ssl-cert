require 'logger'

module GoogleSslCert
  class Logger < ::Logger
    def initialize(*args)
      super
      self.formatter = Formatter.new
      self.level = log_level
    end

    def log_level
      if ENV['DEBUG']
        :debug
      else
        ENV['GSC_LOG_LEVEL'] || :info # note: only respected when config.logger not set in config/app.rb
      end
    end

    def format_message(severity, datetime, progname, msg)
      line = if @logdev.dev == $stdout || @logdev.dev == $stderr
        msg # super simple format if stdout
      else
        super # use the configured formatter
      end
      line =~ /\n$/ ? line : "#{line}\n"
    end
  end
end
