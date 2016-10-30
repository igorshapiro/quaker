# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quaker/version'

Gem::Specification.new do |spec|
  spec.name          = "quaker"
  spec.version       = Quaker::VERSION
  spec.authors       = ["Igor Shapiro"]
  spec.email         = ["shapigor@gmail.com"]

  spec.summary       = %q{Preprocessor for docker-compose}
  spec.description   = %q{
    Extend docker-compose by adding support to:
    - include files
    - run services (and their dependencies) by tag
    - automatically detect service directories by git repository
  }
  spec.homepage      = "https://igorshapiro.github.io/quaker/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "deep_merge", "~> 1.1.1"
  spec.add_runtime_dependency "git_clone_url", "~> 2.0.0"
  spec.add_runtime_dependency "clamp", "~> 1.0.1"
end
