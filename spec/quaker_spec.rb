require 'spec_helper'
require 'fileutils'

describe Quaker do
  describe 'Integration' do
    PREFIX = 'docker/services'
    FILES = {
      "all.yml" => """---
include:
- infra.yml
billing:
  depends_on:
  - mongo
  tags:
  - billing
      """,

      "infra.yml" => """---
redis:
  image: redis
mongo:
  image: mongo
      """
    }
    it 'outputs correct result' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do
          FileUtils.mkdir_p PREFIX
          FILES.each{|name, content|
            File.open("#{PREFIX}/#{name}", "w") {|f|
              f.write(content)
            }
          }
          expect{
            ARGV << "-t"
            ARGV << "billing"
            Quaker::run
          }.to output("""---
version: '2'
services:
  billing:
    depends_on:
    - mongo
  mongo:
    image: mongo
""").to_stdout
        end
      end
    end
  end
end
