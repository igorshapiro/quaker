require 'spec_helper'
require 'open3'
require 'yaml'

EXE_PATH = File.expand_path('../../exe/quaker', __FILE__)
FIXTURES_PATH = File.expand_path('../fixtures', __FILE__)

def exec args
  cmd = "cd #{FIXTURES_PATH} && bundle exec #{EXE_PATH} #{args}"
  stdin, stdout, stderr = Open3.popen3(cmd)
  stdout_content = stdout.read
  begin
    YAML.load(stdout_content)
  rescue Exception => ex
    STDERR.puts "Error parsing: #{stdout_content}"
    STDERR.puts "STDERR: #{stderr.read}"
  end
end

describe Quaker do
  let (:fixtures_dir) {  }
  describe 'Integration' do
    it 'outputs correct result' do
      spec = exec '-t ui'

      services = spec["services"]
      expect(services).not_to be_empty
      expect(services.keys).to contain_exactly 'web', 'redis'
    end
  end
end
