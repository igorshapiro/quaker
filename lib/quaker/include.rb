require 'yaml'

class Include
  INCLUDE_KEY = 'include'
  def process filepath
    dir = File.join(filepath, '..')
    spec = YAML.load(File.read(filepath))
    return spec unless spec.has_key?(INCLUDE_KEY)

    spec.delete(INCLUDE_KEY).inject(spec) { |acc, file|
      spec.merge(process File.expand_path(file, dir))
    }
  end
end
