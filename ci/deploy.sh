#!/bin/bash

set -e
set -x

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

if [ "$(whoami)" != "rubby" ] ; then
	sudo -u rubby -i "$PROGDIR/$PROGNAME"
	exit
fi

cd ~/dashboard

export RAILS_ENV=production
PATH=./bin:$PATH
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.1.2

echo --- Checking out code

git fetch -q
git checkout -f "$BUILDBOX_COMMIT"
git submodule update --init

echo --- Bundler

bundle check || bundle install

echo --- Running DB migrations

rake db:migrate

echo --- Restarting unicorn

readonly unicorn_pid=$(cat /tmp/unicorn.pid)
if [ "$unicorn_pid" != "" ] ; then
	bundle exec rake unicorn:graceful_stop
	while ps -p $unicorn_pid > /dev/null; do printf . ; sleep 0.2; done;
fi
bundle exec rake unicorn:start
