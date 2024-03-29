# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'colibri_auth_devise'
  s.version     = '1.0'
  s.summary     = 'Provides authentication and authorization services for use with Colibri by using Devise and CanCan.'
  s.description = s.summary

  s.required_ruby_version = '>= 1.9.3'
  s.author      = ''
  s.email       = ''
  s.homepage    = ''
  s.license     = ''

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  colibri_version = '~> 0.8'

  s.add_dependency 'colibri_core', colibri_version
  s.add_dependency 'devise', '~> 3.2.3'
  s.add_dependency 'devise-encryptable', '0.1.2'
  s.add_dependency 'cancan', '~> 1.6.10'

  s.add_dependency 'json'
  s.add_dependency 'multi_json'

  s.add_development_dependency 'colibri_backend', colibri_version
  s.add_development_dependency 'colibri_frontend', colibri_version
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'sass-rails', '~> 4.0.0'
  s.add_development_dependency 'coffee-rails', '~> 4.0.0'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'email_spec', '~> 1.5.0'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'shoulda-matchers', '~> 1.5'
  s.add_development_dependency 'capybara', '~> 2.2.1'
  s.add_development_dependency 'database_cleaner', '~> 1.2.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'poltergeist', '~> 1.5.0'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
  s.add_development_dependency 'pry'
end
