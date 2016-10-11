require 'spec_helper'
require 'quaker/templates'

describe 'templates' do
  specs = {
    'service_template' => {
      'environment' => {
        'NODE_ENV' => 'development'
      },
      'tags' => ['tag1*']
    },
    'svc1' => {
      'tags' => ['tag1']
    },
    'svc2' => {
      'tags' => ['tag2']
    }
  }

  let (:service_template) { specs['service_template'] }
  let (:applied) { Quaker::Templates.new.apply specs }

  it 'removes *_template' do
    expect(applied).not_to include 'service_template'
  end

  it 'keeps non *_template' do
    expect(applied).to include *%w(svc1 svc2)
  end

  it 'merges template with service, matching tag' do
    svc1 = applied['svc1']
    expect(svc1).to include({
      'environment' => service_template['environment']
    })
  end

  it 'does not merge tags attribute from template' do
    svc1 = applied['svc1']
    expect(service_template['tags']).to include 'tag1*'
    expect(svc1['tags']).not_to include 'tag1*'
  end

  it 'does not merge template with services not matching tag' do
    expect(applied['svc2']).not_to include('environment')
  end

  it 'does not override service tags' do
    specs['svc1']['environment'] = {'RUBY_ENV' => 'dev'}
    expect(applied['svc1']).to include({
      'environment' => {
        'RUBY_ENV' => 'dev',
        'NODE_ENV' => 'development'
      }
    })
  end
end
