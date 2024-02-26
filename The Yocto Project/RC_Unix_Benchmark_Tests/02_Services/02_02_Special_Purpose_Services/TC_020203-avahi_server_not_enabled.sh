#!/bin/bash

TEST_TITLE="Ensure Avahi Server is not enabled"
TEST_ID=020203

# Initialize an indicator varioable
AVAHI_PRESENT=false

# List of known Avahi server binaries or files
known_avahi_files=(
    "/usr/sbin/avahi-daemon"
    "/etc/avahi/avahi-daemon.conf"
)

# Check for Avahi server executable and configuration files
for file in "${known_avahi_files[@]}"; do
    if [ -f "$file" ]; then
        AVAHI_PRESENT=true
        message="Found Avahi Server file at $file"
        break # stop checking if any file is found
    fi
done

# Optionally, check if the Avahi service is active
if systemctl is-active --quiet avahi-daemon &>/dev/null; then
    AVAHI_PRESENT=true
    message="Avahi Server is active"
fi

# Evaluate the ressult
if $AVAHI_PRESENT; then
    echo "$TEST_ID:$TEST_TITLE:1:$message"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi
