set -e
set -x

RAILS_ENV=test
PATH=./bin:$PATH
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.1.2

echo --- Bundler
bundle check || bundle install

echo --- Preparing test database
bundle exec rake db:drop db:create db:schema:load

echo --- Testing
bundle exec rspec
