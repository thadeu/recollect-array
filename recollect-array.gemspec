# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'recollect/array/version'

Gem::Specification.new do |spec|
  spec.name          = 'recollect-array'
  spec.version       = Recollect::Array::VERSION
  spec.authors       = ['Thadeu Esteves']
  spec.email         = ['tadeuu@gmail.com']
  spec.summary       = 'Simple wrapper to filter array using Ruby and simple predicate conditions'
  spec.description   = 'Filter collections using predicates like Ransack gem.'
  spec.homepage      = 'https://github.com/thadeu/recollect-array'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = '>= 2.5.8'
  spec.require_paths = ['lib']

  spec.add_dependency 'base_x', '~> 0.8.1'
  spec.add_dependency 'rbnacl', '~> 7.0'
  spec.add_development_dependency 'bundler', '>= 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.70'

  # spec.metadata['rubygems_mfa_required'] = 'true'
end
