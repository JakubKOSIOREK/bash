#!/bin/bash

TEST_TITLE="Ensure rsyslog default file permissions configured"
TEST_ID=04020104
RSYSLOG_CONF="/etc/syslog.conf"
RSYSLOG_DIR="/etc/syslog.d"
EXPECTED_MODE="0640"

# Function to check if $FileCreateMode is set correctly
check_file_create_mode() {
    local file=$1
    local mode
    mode=$(grep "^\\\$FileCreateMode" "$file" | awk '{print $2}' | tail -1)
    if [[ -z "$mode" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1: \$FileCreateMode not set in $file"
        return 1
    elif [[ "$mode" > "$EXPECTED_MODE" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1: Less restrictive \$FileCreateMode than expected in $file $mode"
        return 1
    fi
    return 0
}

# Check if the rsyslog configuration file exists
if [ ! -f "$RSYSLOG_CONF" ] && [ ! -d "$RSYSLOG_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: Rsyslog configuration files not found"
    exit 2
fi

# Check rsyslog configuration files for $FileCreateMode
failure=0
if [ -f "$RSYSLOG_CONF" ]; then
    if ! check_file_create_mode "$RSYSLOG_CONF"; then
        failure=1
    fi
fi

if [ -d "$RSYSLOG_DIR" ]; then
    for conf_file in "$RSYSLOG_DIR"/*.conf; do
        if [ -f "$conf_file" ]; then
            if ! check_file_create_mode "$conf_file"; then
                failure=1
            fi
        fi
    done
fi

# Final result
if [ "$failure" -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:One or more required settings are incorrect"
    exit 1
fi
