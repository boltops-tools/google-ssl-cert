module GoogleSslCert
  class Base
    include GoogleServices
    include Logging
    extend Memoist

    def initialize(options={})
      @options = options
      @project_id = options[:google_project] || ENV['GOOGLE_PROJECT'] || raise("GOOGLE_PROJECT env variable is not set. It's required.")
    end

  private
    def parent
      "projects/#{project_number}"
    end

    @@project_number = nil
    def project_number
      return @@project_number if @@project_number
      project = resource_manager.project(@project_id)
      @@project_number = project.project_number
    end
  end
end

