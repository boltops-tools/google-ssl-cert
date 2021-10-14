module GoogleSslCert::Helpers
  module ProjectNumber
  private
    def parent
      "projects/#{project_number}"
    end

    @@project_number = nil
    def project_number
      return @@project_number if @@project_number
      project = resource_manager.project(ENV['GOOGLE_PROJECT'])
      @@project_number = project.project_number
    end
  end
end
