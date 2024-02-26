#!/bin/bash

TEST_TITLE="Ensure permissions on /etc/shadow- are configured"
TEST_ID=060107
FILE="/etc/shadow-"

EXPECTED_PERMISSIONS="600"
EXPECTED_OWNER=0  # UID of root
EXPECTED_GROUP=0  # GID of root

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$FILE >> No such file or directory."
    exit 2
fi

# Check permissions, owner, and group of the file
permissions=$(stat -c "%a %u %g" "$FILE")

# If permissions, owner, and group are not as expected, then test fails
if [[ $permissions != "$EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Current $permissions, Expected $EXPECTED_PERMISSIONS $EXPECTED_OWNER $EXPECTED_GROUP."
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
