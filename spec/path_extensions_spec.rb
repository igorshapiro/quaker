require 'spec_helper'
require 'quaker/path_extensions'

describe Quaker::PathExtensions do
  describe 'expand' do
    it 'handles missing volumes' do
      services = {
        'svc1' => { 'build' => './here'}
      }
      expect(subject.expand(services)).to eq services
    end

    it 'replaces `~` with the `build` path' do
      services = {
        'svc1' => {
          'build' => './here',
          'volumes' => ['~/logs:/logs']
        }
      }
      expect(subject.expand(services)['svc1']).to include 'volumes' => ['./here/logs:/logs']
    end
  end
end
