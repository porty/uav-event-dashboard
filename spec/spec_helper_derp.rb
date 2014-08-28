
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'

#require File.expand_path("../../config/manualcoverage", __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Force new expect syntax!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # config.before(:all) do
  #   VCR.configure do |vcr_config|
  #     vcr_config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  #     vcr_config.hook_into :webmock # or :fakeweb
  #
  #     # allow codeclimate to receive coverage data
  #     vcr_config.ignore_hosts 'codeclimate.com'
  #   end
  # end
end

# helper to run test code in a different environment
def with_rails_env(env)
  old_env = Rails.env
  Rails.env = env
  yield
ensure
  Rails.env = old_env
end
