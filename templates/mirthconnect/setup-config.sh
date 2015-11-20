#!/bin/bash

CONF="conf/mirth.properties"

logSetting() {
    echo "Setting mirth.properties: $1 = $2"
}

logDefault() {
    echo "Using default for $1"
}

if [ -n "$MIRTH_DATABASE" ]; then
    logSetting database "$MIRTH_DATABASE"
    sed -i "s|database =.*|database = $MIRTH_DATABASE|" $CONF
else
    logDefault database
fi

if [ -n "$MIRTH_DATABASE_URL" ]; then
    logSetting 'database.url' '[FILTERED]'
    sed -i \
        "s|database\.url =.*|database.url = $MIRTH_DATABASE_URL|" \
        $CONF
else
    logDefault 'database.url'
fi

if [ -n "$MIRTH_DATABASE_USERNAME" ]; then
    logSetting 'database.username' '[FILTERED]'
    sed -i \
        "s|database\.username =.*|database.username = $MIRTH_DATABASE_USERNAME|" \
        $CONF
else
    logDefault 'database.username'
fi

if [ -n "$MIRTH_DATABASE_PASSWORD" ]; then
    logSetting 'database.password' '[FILTERED]'
    sed -i \
        "s|database\.password =.*|database.password = $MIRTH_DATABASE_PASSWORD|" \
        $CONF
else
    logDefault 'database.password'
fi
