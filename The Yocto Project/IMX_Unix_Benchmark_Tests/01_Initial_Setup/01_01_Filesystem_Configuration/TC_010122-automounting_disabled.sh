#!/bin/bash

TEST_TITLE="Disable Automounting"
TEST_ID=010122

# Check if autofs package is installed
package_status=$(dpkg -s autofs 2>&1)

# If package is not installed or package information is not available, then test is not implemented
if [[ $package_status == *"package 'autofs' is not installed"* || $package_status == *"no information is available"* ]]
then
    echo "$TEST_ID:$TEST_TITLE:2:Automounting package is not installed or package information is not available"
    exit 2
fi

# Check if autofs service is enabled
service_status=$(systemctl is-enabled autofs 2>&1)

# If service is enabled, then test fails
if [[ $service_status == "enabled" ]]
then
    echo "$TEST_ID:$TEST_TITLE:1:Automounting is enabled"
    exit 1
fi

# If service file does not exist, then test pass
if [[ $service_status == *"No such file or directory"* ]]
then
    echo "$TEST_ID:$TEST_TITLE:0" 
    exit 0
fi
