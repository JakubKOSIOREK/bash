#!/bin/bash
TEST_TITLE="Ensure only strong MAC algorithms are used in SSH"
TEST_ID=050214
WEAK_MAC_ALGORITHMS=("hmac-md5" "hmac-md5-96" "hmac-ripemd160" "hmac-sha1" "hmac-sha1-96" "umac-64@openssh.com" "umac-128@openssh.com" "hmac-md5-etm@openssh.com" "hmac-md5-96-etm@openssh.com" "hmac-ripemd160-etm@openssh.com" "hmac-sha1-etm@openssh.com" "hmac-sha1-96-etm@openssh.com" "umac-64-etm@openssh.com" "umac-128-etm@openssh.com")

# Function to check for weak MAC algorithms in SSH configuration
check_weak_macs() {
    local macs
    macs=$(sshd -T | grep macs | awk '{print $2}')

    for mac in "${WEAK_MAC_ALGORITHMS[@]}"; do
        if [[ $macs == *"$mac"* ]]; then
            echo "$TEST_ID:$TEST_TITLE:1:Weak MAC algorithm found $mac"
            return 1
        fi
    done
    return 0
}

# Check for weak MAC algorithms in SSH configuration
if ! check_weak_macs; then
    exit 1
fi

# If no weak MAC algorithms found, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
