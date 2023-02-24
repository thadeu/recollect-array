# frozen_string_literal: true

# $:.push File.expand_path('lib', __dir__)
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'nano/version'

Gem::Specification.new do |s|
  s.name        = 'nano-collection-filter'
  s.version     = Nano::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Thadeu Esteves Jr']
  s.email       = ['tadeuu@gmail.com']
  s.homepage    = 'https://github.com/thadeu/nano-collection-filter'
  s.summary     = '%q{Simple filter array for Pure Ruby with conditions}'
  s.description = '%q{Filter in Array collection using predicates like Ransack gem.}'
  s.license = 'MIT'

  s.add_development_dependency 'bundler', '>= 2.3'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '>= 3'
  s.add_development_dependency 'rubocop', '~> 0.70'

  s.required_ruby_version = '>= 2.5.8'
  s.require_paths = ['lib']

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.metadata['rubygems_mfa_required'] = 'true'
end
