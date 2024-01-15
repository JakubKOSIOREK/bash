#!/bin/bash

TEST_TITLE="Ensure time synchronization is in use"
TEST_ID=02020101

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Initialize variables
timesyncd_status="inactive"
chrony_installed=1
ntp_installed=1
missing_commands=""

# Check if systemd-timesyncd is enabled
if command_exists systemctl; then
    timesyncd_status=$(systemctl is-enabled systemd-timesyncd 2>/dev/null)
else
    missing_commands+="systemctl "
fi

# Check if chrony or ntp packages are installed
if command_exists dpkg; then
    chrony_installed=$(dpkg -s chrony 2>/dev/null | grep -q '^Status: install ok installed$'; echo $?)
    ntp_installed=$(dpkg -s ntp 2>/dev/null | grep -q '^Status: install ok installed$'; echo $?)
else
    missing_commands+="dpkg "
fi

# Determine the overall result
if [[ "$timesyncd_status" == "enabled" ]] || [[ "$chrony_installed" -eq 0 ]] || [[ "$ntp_installed" -eq 0 ]]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
elif [[ -n "$missing_commands" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Not Implemented - Missing commands: $missing_commands"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:1"
    exit 1
fi
