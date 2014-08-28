set -e
set -x

RAILS_ENV=test

echo --- Bundler
bundle check || bundle install

echo --- Preparing test database
bundle exec rake db:drop db:create db:schema:load

echo --- Testing
bundle exec rspec
