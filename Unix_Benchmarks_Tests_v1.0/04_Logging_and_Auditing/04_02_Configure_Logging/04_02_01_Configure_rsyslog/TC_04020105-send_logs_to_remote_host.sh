#!/bin/bash

TEST_TITLE="Ensure rsyslog is configured to send logs to a remote log host"
TEST_ID=04020105
RSYSLOG_CONF="/etc/syslog.conf"
RSYSLOG_DIR="/etc/syslog.d"

# Function to check for remote logging configuration
check_remote_logging() {
    local file=$1
    if grep -Eq "^[^#]*@\S+" "$file" || grep -Eq "^[^#]*action\(.*target=\"\S+\".*\)" "$file"; then
        return 0
    else
        return 1
    fi
}

# Check if rsyslog is configured for remote logging
configured=0
if [ -f "$RSYSLOG_CONF" ]; then
    if check_remote_logging "$RSYSLOG_CONF"; then
        configured=1
    fi
fi

if [ -d "$RSYSLOG_DIR" ]; then
    for conf_file in "$RSYSLOG_DIR"/*.conf; do
        if [ -f "$conf_file" ]; then
            if check_remote_logging "$conf_file"; then
                configured=1
                break
            fi
        fi
    done
fi

# Output the result
if [ "$configured" -eq 1 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Remote logging is not configured"
    exit 1
fi
