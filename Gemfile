source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'
# Database for Active Record
gem 'mysql2'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the
# background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# ----

# Config management via .env files
gem 'dotenv-rails'

# Foreign key helpers
gem 'foreigner'

# gem 'faraday'
# Provides JSON encode/decode middleware for Faraday
# gem "faraday_middleware"
# gem 'bugsnag'

gem 'uglifier'

group :test do
  # Rspec for all tests except for acceptance testing
  gem 'rspec-rails'

  # Controls time within tests
  gem 'timecop'

  # Mock http requests without reaching in too deep
  gem 'webmock', require: true

  # Provides code coverage in dev
  gem 'simplecov', require: false

  # Resets the database state between test runs
  gem 'database_cleaner'

end
