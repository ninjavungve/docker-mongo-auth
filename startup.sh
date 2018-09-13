#!/bin/bash
set -m

mongodb_cmd="mongod"
cmd="$mongodb_cmd"

if [ "$AUTH" == "YES" ]; then
    cmd="$cmd --auth"
fi

$cmd &

if [ ! -f /data/db/.config_auth_mongodb_success ]; then
    /config_auth_mongodb.sh
fi

fg
