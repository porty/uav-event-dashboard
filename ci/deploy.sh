#!/bin/bash

set -e
set -x

if [ "$(whoami)" != "rubby" ] ; then
	sudo -u rubby -i "$PROGDIR/$PROGNAME"
	exit
fi

cd ~/dashboard

export RAILS_ENV=production

echo --- Checking out code

git fetch -q
git checkout -f "$BUILDBOX_COMMIT"
git submodule update --init

echo --- Bundler

bundle check || bundle install

echo --- Running DB migrations

rake db:migrate

echo --- Restarting unicorn

bundle exec rake unicorn:restart
