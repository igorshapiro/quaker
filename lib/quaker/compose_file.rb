require 'yaml'

class ComposeFile
  def build spec
    {
      'version' => '2',
      'services' => spec
    }.to_yaml
  end
end
