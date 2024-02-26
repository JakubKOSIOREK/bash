#!/bin/bash

TEST_TITLE="Ensure Firewall software is installed"
TEST_ID=03050101

# List of firewall software to check
FIREWALLS_LIST=("ufw" "nftables" "iptables" "firewalld")

# Initialize the variable to store the names of installed firewall software
installed_firewalls=""

check_firewall_command() {
    local command=$1

    # Use 'command -v' to check if the command is available in the system path
    if command -v "$command" >/dev/null; then
        installed_firewalls+="$command "
    fi
}

# Iterate over the list of firewall software
for package in "${FIREWALLS_LIST[@]}"; do
    check_firewall_command "$package"
done

# Determine the overall result based on the availbility of firewall software
if [ -n "$installed_firewalls" ]; then
    echo "$TEST_ID:$TEST_TITLE:0:" # PASS
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:No firewall software installed" # FAIL
    exit 1
fi
