$:.push File.expand_path('../lib', __FILE__)

require 'cb/version'

Gem::Specification.new do |spec|
  spec.name = 'cb-api-client'
  spec.version = CB::VERSION
  spec.summary = 'CB API Client for Ruby'
  spec.description = 'The CB API Client for Ruby. Provides a simple client to the main CB APIs'
  spec.authors = 'CareerBuilder'
  spec.homepage = 'http://github.com/cbdr/cb-api-client-ruby'
  spec.license = 'Apache 2.0'
  spec.email = ['consumerdevelopment@careerbuilder.com']

  spec.require_paths = ['lib']
  spec.files += Dir['lib/**/*.rb']

  spec.add_dependency 'httparty', '~> 0.13'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'byebug', '~> 6.0'
end
