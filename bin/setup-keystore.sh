#!/bin/bash

BIN_PATH=`dirname $(readlink -f $0)`
ENV_PATH="$BIN_PATH/../.aptible.env"

KEYSTORE_PATH="$JAVA_HOME/jre/lib/security/cacerts"
KEYSTORE_PASSWORD="changeit"

echoerr() { echo "$@" 1>&2; }

if [ -e "$ENV_PATH" ]; then
    source "$ENV_PATH"
else
    echoerr "No .env file found, skipping .env import"
fi

if [ -n "$DB_CERT" ]; then
    echo "$DB_CERT" > /tmp/db.crt
    keytool -import \
            -file /tmp/db.crt \
            -alias PostgreSQL \
            -keystore "$KEYSTORE_PATH" \
            -storepass "$KEYSTORE_PASSWORD" \
            -noprompt
    rm /tmp/db.crt
else
    echoerr 'No $DB_CERT env variable found, skipping keystore modification'
fi
