require 'spec_helper'
require 'quaker/tag_matcher'

describe Quaker::TagMatcher do
  describe 'matches' do
    examples = [
      { tags: %w(a b), patterns: [], matches: true },
      { tags: %w(a b), patterns: nil, matches: true },
      { tags: [], patterns: %w(a), matches: false },
      { tags: %w(a), patterns: %w(a), matches: true},
      { tags: %w(a b), patterns: %w(a), matches: true},
      { tags: %w(ab), patterns: %w(a*), matches: true},
      { tags: %w(c), patterns: %w(a*), matches: false},
      { tags: %w(c), patterns: %w(a*), matches: false},
    ].each {|example|
      tags = example[:tags]
      patterns = example[:patterns]
      matches = example[:matches]

      it "Pattern #{patterns || 'nil'} matches #{tags || 'nil'} => #{matches}" do
        expect(subject.match(tags, patterns)).to eq matches
      end
    }
  end
end
