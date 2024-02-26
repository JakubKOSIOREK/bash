#!/bin/bash

TEST_TITLE="Ensure Talk Client is not installed"
TEST_ID=020303

# List of packages/services to check
SERVICES=("talk")

# Initialize the failure flag as false
FAILURE_FLAG=false

# Function to check service status
check_service() {
    local service=$1
    EXECUTABLE_PRESENT=false
    SERVICE_ACTIVE=false

    # Check for the executable
    if command -v "$service" &>/dev/null;then
        EXECUTABLE_PRESENT=true
    fi

    # Optionally, check if service is active
    if systemctl is-active --quiet "$service" &>/dev/null; then
        SERVICE_ACTIVE=true
    fi

    # Evaluate ressults for this service
    if $EXECUTABLE_PRESENT || $SERVICE_ACTIVE; then
        echo "$TEST_ID:$TEST_TITLE:1:$service is present or service is active"
        FAILURE_FLAG=true
    fi
}

# Iterate over services and check each
for service in "${SERVICES[@]}"; do
    check_service "$service"
done

# Evaluate final results
if $FAILURE_FLAG; then
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
