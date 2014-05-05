require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'shoulda-matchers'
require 'ffaker'
require 'database_cleaner'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

require 'colibri/testing_support/factories'
require 'colibri/testing_support/url_helpers'
require 'colibri/testing_support/controller_requests'
require 'colibri/testing_support/authorization_helpers'
require 'colibri/testing_support/capybara_ext'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  # config.filter_run focus: true

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
  end

  config.after do
    DatabaseCleaner.clean
    Colibri::Ability.abilities.delete(AbilityDecorator) if Colibri::Ability.abilities.include?(AbilityDecorator)
  end

  config.include FactoryGirl::Syntax::Methods
  config.include Colibri::TestingSupport::UrlHelpers
  config.include Colibri::TestingSupport::ControllerRequests, :type => :controller
  config.include Devise::TestHelpers, :type => :controller
  config.include Rack::Test::Methods, :type => :feature

  Capybara.javascript_driver = :poltergeist
end

if defined? CanCan::Ability
  class AbilityDecorator
    include CanCan::Ability

    def initialize(user)
      cannot :manage, Colibri::Order
    end
  end
end
