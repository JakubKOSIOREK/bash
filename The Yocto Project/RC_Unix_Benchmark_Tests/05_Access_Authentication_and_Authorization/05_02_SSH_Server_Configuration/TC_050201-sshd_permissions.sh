#!/bin/bash
TEST_TITLE="Ensure permissions on /etc/ssh/sshd_config are configured"
TEST_ID=050201
SSHD_CONFIG="/etc/sshd_config"
EXPECTED_PERMISSIONS="600"
EXPECTED_OWNER=0  # UID of root
EXPECTED_GROUP=0  # GID of root

# Check if sshd_config file exists
if [[ ! -f "$SSHD_CONFIG" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSHD_CONFIG >> No such file or directory."
    exit 2
fi

# Check permissions, owner, and group of the sshd_config file
permissions=$(stat -c "%a %u %g" "$SSHD_CONFIG")

# If permissions, owner, and group are not as expected, then test fails
if [[ $permissions != "$EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Current $permissions, Expected $EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
