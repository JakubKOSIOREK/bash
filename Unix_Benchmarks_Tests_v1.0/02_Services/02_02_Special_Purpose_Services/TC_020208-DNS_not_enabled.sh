#!/bin/bash

TEST_TITLE="Ensure DNS Server is not enabled"
TEST_ID=020208
SERVICE_01="named"
SERVICE_02="dnsmasq"

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
if systemctl list-unit-files | grep -q "$SERVICE_02"; then
    installed_services+=("$SERVICE_02")
fi

# Check if any services are installed
if [ ${#installed_services[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:2:No DNS Server services found"
    exit 2
fi

# Check service status
for service in "${installed_services[@]}"; do
    if check_service $service; then
        echo "$TEST_ID:$TEST_TITLE:1:$service is enabled"
        exit 1
    fi
done

echo "$TEST_ID:$TEST_TITLE:0"
exit 0
