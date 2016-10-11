module Quaker
  require 'open3'
  require 'git_clone_url'

  class GitResolver
    # Parses repository url to { username: ..., repository: ...}
    def parse_url url
      begin
        uri = GitCloneUrl.parse(url)

        if uri.path.match(/^\/?(.*?)\/(.*?)(.git)?$/)
          return { username: $1, repo: $2 }
        end
      rescue URI::InvalidComponentError
        $stderr.puts "ERROR: Invalid git url: #{url}"
      end
      url
    end

    def find_dir_for_repo repo
      dir = Dir.glob('*')
        .select {|f| File.directory? f}
        .select {|subdir|
          _stdin, stdout, _stderr = Open3.popen3("cd #{subdir} && git remote -v | awk '{print $2}'")
          stdout.each_line
            .map(&:strip)
            .map {|l| parse_url(l) }
            .include?(parse_url(repo))
        }
        .first
      return nil unless dir
      "./#{dir}"
    end

    def resolve services_map
      for _, spec in services_map
        git_repo = spec.delete("git")
        next unless git_repo

        dir = find_dir_for_repo git_repo

        $stderr.puts "ERROR: Unable to find dir for repo #{git_repo}" and return unless dir

        spec["build"] = dir
      end
      services_map
    end
  end
end
