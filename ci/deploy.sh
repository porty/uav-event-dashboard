#!/bin/bash

set -e
set -x

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

if [ "$(whoami)" != "rubby" ] ; then
	sudo -u rubby -i "$PROGDIR/$PROGNAME" "$BUILDBOX_COMMIT"
	exit
fi

readonly BUILDBOX_COMMIT="$1"

cd ~/dashboard

export RAILS_ENV=production
PATH=./bin:$PATH
set +x
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.1.2
set -x

echo --- Checking out code

git fetch -q
git checkout -q -f "$BUILDBOX_COMMIT"
git submodule update --init

echo --- Bundler

bundle check || bundle install

echo --- Running DB migrations

rake db:migrate

echo --- Restarting unicorn

bundle exec rake unicorn:restart
