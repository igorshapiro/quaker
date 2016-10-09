require 'spec_helper'

describe Quaker::GitResolver do
  describe 'resolve' do
    before :each do
      Dir.chdir File.expand_path '../fixtures', __FILE__
      puts `git submodule init && git submodule update`
    end

    let (:manifest) {
      {
        'svc_by_https' => { 'git' => 'https://github.com/igorshapiro/quaker-svc1' },
        'svc_by_git' => { 'git' => 'git@github.com:igorshapiro/quaker-svc1.git' },
        'invalid_git' => { 'git' => 'git@invalid_git'}
      }
    }

    it 'replaces `git` by `build` if repository found' do
      expect(subject.resolve(manifest)).to eq({
        'svc_by_https' => { 'build' => './svc1' },
        'svc_by_git' => { 'build' => './svc1' },
        'invalid_git' => { 'build' => nil }
      })
    end

    it 'writes url parse error to `stderr`' do
      expect {
        subject.resolve(manifest)
      }.to output("ERROR: Unable to find dir for repo git@invalid_git\n").to_stderr
    end
  end
end
