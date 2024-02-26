#!/bin/bash

TEST_TITLE="Ensure remote rsyslog messages are only accepted on designated log hosts"
TEST_ID=04020106
RSYSLOG_CONF="/etc/syslog.conf"
RSYSLOG_DIR="/etc/syslog.d"
IS_LOG_HOST="no" # Change to "yes" if this system is a designated log host
COMMENT_SIGN="#" # Use "#" for commented, "" for activ lines

# Function to check rsyslog remote message configuration
check_remote_messages_config() {
    local file=$1
    local commented_modload_imtcp=$(grep -E "^$COMMENT_SIGN\$ModLoad imtcp" "$file")
    local commented_inputtcpserverrun=$(grep -E "^$COMMENT_SIGN\$InputTCPServerRun" "$file")

    if [ "$IS_LOG_HOST" = "yes" ]; then
        if [ -n "$commented_modload_imtcp" ] && [ -n "$commented_inputtcpserverrun" ]; then
            # Both entries are commented out as expected
            return 0
        else
            # At least one entry is not commented out
            return 1
        fi
    else
        if [ -z "$commented_modload_imtcp" ] || [ -z "$commented_inputtcpserverrun" ]; then
            # Entries ar missing or both are active whitch is correct for non-log hosts
            return 0
        else
            # Incorrect configuration for a non-log host
            return 1
        fi
    fi
}

# Check if the rsyslog configuration file exists
if [ ! -f "$RSYSLOG_CONF" ] && [ ! -d "$RSYSLOG_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: Rsyslog configuration files not found"
    exit 2
fi

# Initialize variable to track the overall test status
test_passed=true
missing_entries=true

# Check rsyslog configuration for remote message settings
if [ -f "$RSYSLOG_CONF" ]; then
    missing_entries=false
    if ! check_remote_messages_config "$RSYSLOG_CONF"; then
        echo "$TEST_ID:$TEST_TITLE:1:Incorrect remote message settings in $RSYSLOG_CONF"
        test_passed=false
    fi
fi

if [ -d "$RSYSLOG_DIR" ]; then
    for conf_file in "$RSYSLOG_DIR"/*.conf; do
        if [ -f "$conf_file" ]; then
            missing_entries=false
            if ! check_remote_messages_config "$conf_file"; then
                echo "$TEST_ID:$TEST_TITLE:1:Incorrect remote message settings in $conf_file"
                test_passed=false
            fi
        fi
    done
fi

if $missing_entries; then
    echo "$TEST_ID:$TEST_TITLE:2:No remote message entries found."
    exit 2
fi

if $test_passed; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    exit 1
fi
