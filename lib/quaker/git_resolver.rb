require 'open3'

class GitResolver
  def find_dir_for_repo repo
    dir = Dir.glob('*')
      .select {|f| File.directory? f}
      .select {|dir|
        stdin, stdout, stderr = Open3.popen3("cd #{dir} && git remote -v")
        out = stdout.gets
        out && out.include?(repo)
      }
      .first
    return nil unless dir
    "./#{dir}"
  end

  def resolve services_map
    for name, spec in services_map
      git_repo = spec.delete("git")
      next unless git_repo

      dir = find_dir_for_repo git_repo

      STDERR.puts "ERROR: Unable to find dir for repo #{git_repo}" and return unless dir

      spec["build"] = dir
    end
    services_map
  end
end
