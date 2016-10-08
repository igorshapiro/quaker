require "quaker/version"

module Quaker
  require 'clamp'

  Clamp do
    parameter "[SPEC_FILE]", "Extended docker-compose file"
    option %w(--tags -t), "TAGS", "tags", multivalued: true

    def default_spec_file
      File.expand_path('docker/services/all.yml', CURRENT_DIR)
    end


    def execute

    end
  end
end
