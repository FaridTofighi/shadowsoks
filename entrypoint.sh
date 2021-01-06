#!/bin/sh
exec ss-server \
    -s $SERVER_ADDR \
    -p $SERVER_PORT \
    -m $METHOD \
    -k ${PASSWORD:-$(hostname)} \
    -d $DNS_ADDRS \
    -t $TIMEOUT \
    -u \
    --plugin v2ray-plugin \
    --plugin-opts "server;fast-open"

#if [[ -f "$PASSWORD_FILE" ]]; then
#    PASSWORD=$(cat "$PASSWORD_FILE")
#fi
#
#if [[ -f "/var/run/secrets/$PASSWORD_SECRET" ]]; then
#    PASSWORD=$(cat "/var/run/secrets/$PASSWORD_SECRET")
#fi
#
#exec ss-server \
#      -s $SERVER_ADDR \
#      -p $SERVER_PORT \
#      -k ${PASSWORD:-$(hostname)} \
#      -m $METHOD \
#      -t $TIMEOUT \
#      -d $DNS_ADDRS \
#      -u \
#      $ARGS
