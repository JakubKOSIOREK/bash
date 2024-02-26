#!/bin/bash
TEST_TITLE="Ensure SSH Idle Timeout Interval is configured"
TEST_ID=050216
MIN_CLIENT_ALIVE_INTERVAL=1
MAX_CLIENT_ALIVE_INTERVAL=300
MAX_CLIENT_ALIVE_COUNT_MAX=3

# Function to check SSH Idle Timeout Interval configuration
check_ssh_idle_timeout() {
    local interval count_max
    interval=$(sshd -T | grep clientaliveinterval | awk '{print $2}')
    count_max=$(sshd -T | grep clientalivecountmax | awk '{print $2}')

    if [[ -z "$interval" || "$interval" -lt "$MIN_CLIENT_ALIVE_INTERVAL" || "$interval" -gt "$MAX_CLIENT_ALIVE_INTERVAL" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:Found $interval, Expected between $MIN_CLIENT_ALIVE_INTERVAL and $MAX_CLIENT_ALIVE_INTERVAL."
        return 1
    fi

    if [[ -z "$count_max" || "$count_max" -gt "$MAX_CLIENT_ALIVE_COUNT_MAX" ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:Found $count_max, Expected $MAX_CLIENT_ALIVE_COUNT_MAX or less."
        return 1
    fi

    return 0
}

# Check SSH Idle Timeout Interval configuration
if ! check_ssh_idle_timeout; then
    exit 1
fi

# If configuration is correct, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
