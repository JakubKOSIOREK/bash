#!/bin/bash

TEST_TITLE="Ensure logrotate is configured"
TEST_ID=0403
LOGROTATE_CONF="/etc/logrotate.conf"
RSYSLOG_ROTATE_CONF="/etc/logrotate.d/rsyslog"

# Check if logrotate.conf exists
if [ ! -f "$LOGROTATE_CONF" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: Logrotate configuration file not found"
    exit 2
fi

# Add your site policy checks here. For example, check for a specific configuration like "rotate 7"
# This is a placeholder function and should be modified according to your policies
check_logrotate_config() {
    local file=$1
    # Example check: Ensure log files are rotated weekly
    if grep -q "weekly" "$file"; then
        return 0
    else
        return 1
    fi
}

# Initialize failure flag
failure=0

# Check main logrotate configuration
if [ -f "$LOGROTATE_CONF" ]; then
    if ! check_logrotate_config "$LOGROTATE_CONF"; then
        echo "$TEST_ID:$TEST_TITLE:1: Logrotate configuration issue in $LOGROTATE_CONF"
        failure=1
    fi
fi

## Example for /etc/logrotate.d/rsyslog file
# Check if /etc/logrotate.d/rsyslog file exists
if [ ! -f "$RSYSLOG_ROTATE_CONF" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: $RSYSLOG_ROTATE_CONF file not found"
    exit 2
fi

# Check rsyslog logrotate configuration
if [ -f "$RSYSLOG_ROTATE_CONF" ]; then
    if ! check_logrotate_config "$RSYSLOG_ROTATE_CONF"; then
        echo "$TEST_ID:$TEST_TITLE:1: Logrotate configuration issue in $RSYSLOG_ROTATE_CONF"
        failure=1
    fi
fi

# Output the final result
if [ "$failure" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    exit 1
fi
