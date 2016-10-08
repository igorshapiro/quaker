require 'yaml'

class Include
  INCLUDE_KEY = 'include'
  def process filepath
    dir = File.join(filepath, '..')
    spec = YAML.load(File.read(filepath))
    return spec unless spec.has_key?(INCLUDE_KEY)

    spec
      .delete(INCLUDE_KEY)
      .map {|file| File.expand_path(file, dir) }
      .inject(spec) { |acc, file| acc.merge(process file) }
  end
end
