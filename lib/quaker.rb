require "quaker/version"
require "quaker/include"
require "quaker/tag_filter"
require "quaker/git_resolver"
require "quaker/templates"
require "quaker/path_extensions"
require "quaker/compose_file"

#:nocov:
module Quaker
  require 'clamp'

  def self.run
    Clamp do
      parameter "[SPEC_FILE]", "Extended docker-compose file"
      option %w(--tags -t), "TAGS", "Filter services (and dependencies) by tag", multivalued: true
      option %w(--dir -d), "DIR", "Specify base directory"
      option %w(--only-deps -T), :flag, "Include only dependencies"

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
        # dump_params

        Dir.chdir dir

        spec = Include.new.process spec_file
        spec = Templates.new.apply spec
        spec = TagFilter.new.filter spec, tags_list, only_deps: only_deps?
        spec = GitResolver.new.resolve spec
        spec = PathExtensions.new.expand spec
        spec = ComposeFile.new.build spec
        puts spec
      end
    end
  end
end
#:nocov:
