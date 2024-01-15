#!/bin/bash

TEST_TITLE="Ensure rsync service is not enabled"
TEST_ID=020216
SERVICES=("rsync")

# Function to check if a service is enabled
check_service() {
    local service=$1
    systemctl is-enabled --quiet $service 2>/dev/null
}

# Check for installed services
installed_services=()
for service in "${SERVICES[@]}"; do
    if systemctl list-unit-files | grep -q "$service"; then
        installed_services+=("$service")
    fi
done

# Check if any services are installed
if [ ${#installed_services[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:2:No rsync services found"
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
