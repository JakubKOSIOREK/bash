#!/bin/bash

TEST_TITLE="Ensure logrotate is configured"
TEST_ID=0403
LOGROTATE_CONF="/etc/logrotate.conf"
RSYSLOG_ROTATE_CONF="/etc/logrotate.d/rsyslog"

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

# Check logrotate configuration
failure=0
if [ -f "$LOGROTATE_CONF" ]; then
    if ! check_logrotate_config "$LOGROTATE_CONF"; then
        echo "$TEST_ID:$TEST_TITLE:1: Logrotate configuration issue in $LOGROTATE_CONF"
        failure=1
    fi
fi

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
    echo "$TEST_ID:$TEST_TITLE:1: Logrotate is not configured correctly according to site policy"
    exit 1
fi
