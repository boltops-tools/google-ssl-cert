module GoogleSslCert
  class Secret
    include GoogleServices
    include Logging
    extend Memoist

    def initialize(options={})
      @options = options
      @project_id = options[:google_project] || ENV['GOOGLE_PROJECT'] || raise("GOOGLE_PROJECT env variable is not set. It's required.")
    end

    # CLI commands:
    #   gcloud secrets create testsecret
    #   gcloud secrets versions add testsecret --data-file="/tmp/testsecret.txt"
    #
    # Secret create docs
    #   https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#secretmanager-create-secret-ruby
    #   https://github.com/googleapis/google-cloud-ruby/blob/af60d07b8f134ebc35bee795d127be614abea353/google-cloud-secret_manager-v1/lib/google/cloud/secret_manager/v1/secret_manager_service/client.rb#L307
    #   https://cloud.google.com/secret-manager/docs/reference/rest/v1/projects.secrets/create
    # Secret Versions add docs
    #   https://github.com/googleapis/google-cloud-ruby/blob/af60d07b8f134ebc35bee795d127be614abea353/google-cloud-secret_manager-v1/lib/google/cloud/secret_manager/v1/secret_manager_service/client.rb#L379
    #   https://cloud.google.com/secret-manager/docs/reference/rest/v1/projects.secrets/addVersion
    #   https://cloud.google.com/secret-manager/docs/reference/rest/v1/SecretPayload
    def save(name, value)
      create_secret(name, value)
      url_path = "#{parent}/secrets/#{name}"
      secret_manager_service.add_secret_version(parent: url_path, payload: {data: value})
      logger.info "Secret saved: #{name}"
    rescue Google::Cloud::AlreadyExistsError => e
      logger.error("#{e.class}: #{e.message}")
    end

    def create_secret(name, value)
      secret = get_secret(name)
      return if secret
      secret_manager_service.create_secret(
        parent: parent,
        secret_id: name,
        secret:    {
          replication: {
            automatic: {}
          }
        }
      )
    end

    def get_secret(name)
      url_path = "#{parent}/secrets/#{name}"
      secret_manager_service.get_secret(name: url_path)
    rescue Google::Cloud::NotFoundError
    end

    # gcloud secrets list
    # gcloud secrets versions access latest --secret testsecret
    def get(name)
      version = @options[:version] || "latest"
      url_path = "#{parent}/secrets/#{name}/versions/#{version}"
      version = secret_manager_service.access_secret_version(name: url_path)
      version.payload.data
    rescue Google::Cloud::NotFoundError => e
      logger.error "WARN: secret #{name.color(:yellow)} not found"
      logger.error e.message
      "NOT FOUND #{name}" # simple string so Kubernetes YAML is valid
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
