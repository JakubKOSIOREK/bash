#!/bin/bash
TEST_TITLE="Ensure permissions on /etc/ssh/sshd_config are configured"
TEST_ID=050201
SSHD_CONFIG="/etc/ssh/sshd_config"
EXPECTED_PERMISSIONS="600"
EXPECTED_OWNER=0  # UID of root
EXPECTED_GROUP=0  # GID of root

# Check if /etc/cron.d directory exists
if [[ ! -f "$SSHD_CONFIG" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SSHD_CONFIG file does not exist"
    exit 2
fi

# Check permissions on /etc/cron.d
permissions=$(stat -c "%a %u %g" "$SSHD_CONFIG")

# If permissions are not 700 or owner is not root or group is not root, then test fails
if [[ $permissions != "$EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Permissions on $SSHD_CONFIG are not correctly configured. Current $permissions, Expected $EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
