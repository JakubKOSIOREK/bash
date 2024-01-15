#!/bin/bash

TEST_TITLE="Ensure LDAP Server are not enabled"
TEST_ID=020206
SERVICE_01="sldap"

# Function to check if a service is enabled
check_service() {
    local service=$1
    systemctl is-enabled --quiet $service 2>/dev/null
}

# Check for installed services
installed_services=()
if systemctl list-unit-files | grep -q "$SERVICE_01"; then
    installed_services+=("$SERVICE_01")
fi

# Check if any services are installed
if [ ${#installed_services[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:2:LDAP Server service not found"
    exit 2
fi

# Initialize flags
service_01_enabled=0

# Check service status
if check_service "$SERVICE_01"; then
    service_01_enabled=1
fi

# Determine the overall result
if [ $service_01_enabled -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:LDAP Server service is enabled"
    exit 1
fi
