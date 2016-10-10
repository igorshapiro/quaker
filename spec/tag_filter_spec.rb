require 'spec_helper'
require 'quaker/tag_filter'

describe Quaker::TagFilter do
  describe 'filter' do
    let(:spec) {
      {
        'svc1' => { 'tags' => ['abcd'] },
        'svc2' => { 'tags' => ['dddd'] }
      }
    }

    it 'filters services by tag' do
      expect(subject.filter spec, ['a*']).to include 'svc1'
    end

    it 'includes all services for empty tags' do
      expect(subject.filter spec, []).to include 'svc1', 'svc2'
      expect(subject.filter spec, nil).to include 'svc1', 'svc2'
    end
  end
end
