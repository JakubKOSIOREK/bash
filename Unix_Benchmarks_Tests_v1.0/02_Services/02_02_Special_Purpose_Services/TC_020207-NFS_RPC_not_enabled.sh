#!/bin/bash

TEST_TITLE="Ensure NFS and RPC are not enabled"
TEST_ID=020207
SERVICE_01="nfs-server"
SERVICE_02="rpcbind"

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
    echo "$TEST_ID:$TEST_TITLE:2:No NFS and RPC services found"
    exit 2
fi

# Initialize flags and list for enabled services
service_01_enabled=0
service_02_enabled=0
enabled_services=()

# Check service status
if check_service "$SERVICE_01"; then
    service_01_enabled=1
    enabled_services+=("$SERVICE_01")
fi
if check_service "$SERVICE_02"; then
    service_02_enabled=1
    enabled_services+=("$SERVICE_02")
fi

# Create message with list of enabled services
additional_message="One or more services are enabled"
if [ ${#enabled_services[@]} -gt 0 ]; then
    additional_message+=" (${enabled_services[*]})"
fi

# Determine the overall result
if [ $service_01_enabled -eq 1 ] || [ $service_02_enabled -eq 1 ]; then
    echo -e "$TEST_ID:$TEST_TITLE:1:$additional_message"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
