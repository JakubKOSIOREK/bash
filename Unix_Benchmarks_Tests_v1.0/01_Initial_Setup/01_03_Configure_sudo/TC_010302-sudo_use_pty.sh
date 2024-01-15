#!/bin/bash
TEST_TITLE="Ensure sudo commands use pty"
TEST_ID=010302

# Check if sudo is configured to use pty
sudo_config=$(grep -Ei '^\s*Defaults\s+([^#]+,\s*)?use_pty(,\s+\S+\s*)*(\s+#.*)?$' /etc/sudoers /etc/sudoers.d/* 2>&1)

# If no configuration is found, then test fails
if [[ -z $sudo_config ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:sudo is not configured to use pty"
    exit 1
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
