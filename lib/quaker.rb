require "quaker/version"
require "quaker/include"
require "quaker/tag_filter"
require "quaker/git_resolver"
require "quaker/compose_file"

module Quaker
  require 'clamp'

  Clamp do
    parameter "[SPEC_FILE]", "Extended docker-compose file"
    option %w(--tags -t), "TAGS", "Filter services (and dependencies) by tag", multivalued: true
    option %w(--dir -d), "DIR", "Specify base directory"

    def default_spec_file
      File.expand_path('docker/services/all.yml', dir)
    end

    def default_dir
      Dir.pwd
    end

    def dump_params
      puts "Spec: #{spec_file}"
      puts "Dir: #{dir}"
    end

    def execute
      dump_params

      Dir.chdir dir

      spec = Include.new.process spec_file
      spec = TagFilter.new.filter spec, tags_list
      spec = GitResolver.new.resolve spec
      spec = ComposeFile.new.build spec
      puts spec
    end
  end
end
