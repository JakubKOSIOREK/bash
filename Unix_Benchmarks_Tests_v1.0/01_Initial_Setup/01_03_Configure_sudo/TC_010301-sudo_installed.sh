#!/bin/bash
TEST_TITLE="Ensure sudo or sudo-ldap is installed"
TEST_ID=010301

# Check if sudo package is installed
package_status_sudo=$(dpkg -s sudo 2>&1)

# Check if sudo-ldap package is installed
package_status_sudo_ldap=$(dpkg -s sudo-ldap 2>&1)

# If both packages are not installed, then test fails
if [[ $package_status_sudo == *"package 'sudo' is not installed"* && $package_status_sudo_ldap == *"package 'sudo-ldap' is not installed"* ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:No sudo packages installed"
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
