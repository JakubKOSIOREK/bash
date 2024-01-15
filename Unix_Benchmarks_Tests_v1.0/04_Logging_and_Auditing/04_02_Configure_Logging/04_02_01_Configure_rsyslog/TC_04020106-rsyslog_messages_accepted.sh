#!/bin/bash

TEST_TITLE="Ensure remote rsyslog messages are only accepted on designated log hosts"
TEST_ID=04020106
RSYSLOG_CONF="/etc/syslog.conf"
RSYSLOG_DIR="/etc/syslog.d"
IS_LOG_HOST="no" # Change to "yes" if this system is a designated log host

# Function to check rsyslog remote message configuration
check_remote_messages_config() {
    local file=$1
    local modload_imtcp=$(grep -E '^\$ModLoad imtcp' "$file")
    local inputtcpserverrun=$(grep -E '^\$InputTCPServerRun' "$file")

    if [ "$IS_LOG_HOST" = "yes" ]; then
        if [ -n "$modload_imtcp" ] && [ -n "$inputtcpserverrun" ]; then
            return 0
        else
            return 1
        fi
    else
        if [ -n "$modload_imtcp" ] || [ -n "$inputtcpserverrun" ]; then
            return 1
        else
            return 0
        fi
    fi
}

# Check rsyslog configuration for remote message settings
if [ -f "$RSYSLOG_CONF" ]; then
    if ! check_remote_messages_config "$RSYSLOG_CONF"; then
        echo "$TEST_ID:$TEST_TITLE:1:Incorrect remote message settings in $RSYSLOG_CONF"
        exit 1
    fi
fi

if [ -d "$RSYSLOG_DIR" ]; then
    for conf_file in "$RSYSLOG_DIR"/*.conf; do
        if [ -f "$conf_file" ]; then
            if ! check_remote_messages_config "$conf_file"; then
                echo "$TEST_ID:$TEST_TITLE:1:Incorrect remote message settings in $conf_file"
                exit 1
            fi
        fi
    done
fi

echo "$TEST_ID:$TEST_TITLE:0:Correct remote message settings"
