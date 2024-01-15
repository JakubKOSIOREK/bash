#!/bin/bash

TEST_TITLE="Ensure Firewall software is installed"
TEST_ID=03050101

installed_firewalls=""
firewalls_list=("ufw" "nftables" "iptables" "firewalld")

# Function to check if a firewall package is installed
check_firewall_package() {
    local package=$1
    local package_status

    package_status=$(dpkg -s "$package" 2>&1 | grep -i status)

    if [[ $package_status == *"install ok installed"* ]]; then
        installed_firewalls+="$package "
        return 0 # Package is installed
    fi
}

# Check the packages
for package in "${firewalls_list[@]}"; do
    check_firewall_package "$package"
done

# Determine the overall result
if [ -n "$installed_firewalls" ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:No firewall software installed"
    exit 1
fi
