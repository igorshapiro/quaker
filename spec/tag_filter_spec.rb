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

    describe 'dependency resolving' do
      it 'raises DependencyResolveError for missing dependencies' do
        spec['svc1']['links'] = ['missing_service:svc']

        expect {
          subject.filter spec, ['abcd']
        }.to raise_error(Quaker::DependencyResolveError,
          /missing_service for service svc1/
        )
      end
    end
  end
end
