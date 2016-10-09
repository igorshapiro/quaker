require 'spec_helper'
require 'quaker/include'

def file name
  File.expand_path(name, Dir.pwd)
end

describe Quaker::Include do
  before :each do
    expect(File).to receive(:read).with('all.yml') {
      "---\ninclude:\n  - included.yml\na: 1"
    }
    expect(File).to receive(:read).with(file('included.yml')) {
      "---\ninclude:\n  - nested_included.yml\nb: 2"
    }
    expect(File).to receive(:read).with(file('nested_included.yml')) {
      "---\nc: 3"
    }
  end

  let (:result) { subject.process 'all.yml' }

  it 'includes files' do
    expect(result).to include 'a' => 1, 'b' => 2, 'c' => 3
  end
end
