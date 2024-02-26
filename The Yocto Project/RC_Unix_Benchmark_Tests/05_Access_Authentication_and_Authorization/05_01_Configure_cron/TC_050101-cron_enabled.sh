#!/bin/bash

TEST_TITLE="Ensure cron daemon is enabled"
TEST_ID=050101

# List of packages/services to check
SERVICES=("cron", "crond")

# Initialize a variable to track the availability of cron services
SERVICE_AVAILABLE=false
SERVICE_ENABLED=false

# Function to check service status
check_service(){
    local service=$1

    # Check if the service executable exists
    if command -v "$service" &>/dev/null; then
        SERVICE_AVAILABLE=true

        # Check if the service is enabled
        if systemctl is-enabled "$service" &>/dev/null; then
            SERVICE_ENABLED=true
        fi
    fi
}

# Iterate over services and check each
for service in "${SERVICES[0]}"; do
    check_service "$service"
done

# Evaluate the overall service status
if [ "$SERVICE_AVAILABLE" = true ]; then
    if [ "$SERVICE_ENABLED" = true ]; then
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
    else
        echo "$TEST_ID:$TEST_TITLE:1: Cron service is installed but not enabled"
        exit 1
    fi
else
        echo "$TEST_ID:$TEST_TITLE:1: No cron services installed"
        exit 1
fi
