module Quaker
  module TagMatcher
    def self.match tags, patterns
      return true if patterns.nil? || patterns.empty?
      return false if tags.nil? || tags.empty?

      patterns.any? {|pattern|
        tags.any? {|tag| pattern_matches_string?(tag, pattern)}
      }
    end

    def self.pattern_matches_string? s, pattern
      s == pattern || wildcard_matches?(s, pattern)
    end

    def self.wildcard_matches? s, pattern
      return false unless pattern.include?('*')
      escaped = Regexp.escape(pattern).gsub('\*','.*?')
      regex = Regexp.new "^#{escaped}$", Regexp::IGNORECASE
      !!(s =~ regex)
    end
  end
end
