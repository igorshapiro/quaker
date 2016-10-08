require "quaker/version"
require "quaker/include"
require "quaker/tag_filter"
require "quaker/compose_file"

module Quaker
  require 'clamp'

  Clamp do
    parameter "[SPEC_FILE]", "Extended docker-compose file"
    option %w(--tags -t), "TAGS", "tags", multivalued: true

    def default_spec_file
      File.expand_path('docker/services/all.yml', Dir.pwd)
    end


    def execute
      puts "Using #{spec_file}"
      spec = Include.new.process spec_file
      spec = TagFilter.new.filter spec, tags_list
      spec = ComposeFile.new.build spec
      puts spec
    end
  end
end
