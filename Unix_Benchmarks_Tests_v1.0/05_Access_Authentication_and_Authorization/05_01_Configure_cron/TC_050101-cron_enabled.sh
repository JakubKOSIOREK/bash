#!/bin/bash

TEST_TITLE="Ensure cron daemon is enabled"
TEST_ID=050101
CRON_SERVICE="crond"

if systemctl list-unit-files | grep -qw "$CRON_SERVICE"; then
    if systemctl is-enabled "$CRON_SERVICE" &>/dev/null; then
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
        
    else
        echo "$TEST_ID:$TEST_TITLE:1: ${CRON_SERVICE} service is installed but not enabled"
        exit 1
    fi
else
    echo "$TEST_ID:$TEST_TITLE:2: ${CRON_SERVICE} service is not installed."
    exit 2

fi
