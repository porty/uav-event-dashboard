#!/bin/bash

set -e
set -x


SLACK_MSG="`git show --format=%aN | head -n1` successfully deployed '`git show --format=%s | head -n1`' $BUILDBOX_COMMIT"
SLACK_MSG_ESCAPED=`echo -n $SLACK_MSG | python -c 'import json,sys; print json.dumps(sys.stdin.read())'`
SLACK_PAYLOAD='payload={"channel": "#uav", "username": "BuildBox", "text": '$SLACK_MSG_ESCAPED', "icon_emoji": ":rocket:"}'
curl -X POST --data-urlencode "$SLACK_PAYLOAD" https://digital8.slack.com/services/hooks/incoming-webhook?token=2UHjNVbT4VGxz4AroOY6FMsB
