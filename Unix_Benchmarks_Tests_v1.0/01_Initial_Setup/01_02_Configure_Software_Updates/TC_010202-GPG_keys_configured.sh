#!/bin/bash
TEST_TITLE="Ensure gnupg is installed"
TEST_ID=010202

# Check if gnupg package is installed
package_status=$(dpkg -s gnupg 2>&1)

# If package is not installed, then test fails
if [[ $package_status == *"package 'gnupg' is not installed"* ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Package 'gnupg' is not installed"
    exit 1
fi

# If package information is not available, then test fails
if [[ $package_status == *"no information is available"* ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:No information is available for gnupg package"
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
