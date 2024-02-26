#!/bin/bash
TEST_TITLE="Ensure only strong Ciphers are used in SSH"
TEST_ID=050213
WEAK_CIPHERS=("3des-cbc" "aes128-cbc" "aes192-cbc" "aes256-cbc" "arcfour" "arcfour128" "arcfour256" "blowfish-cbc" "cast128-cbc" "rijndael-cbc@lysator.liu.se")

# Function to check for weak ciphers in SSH configuration
check_weak_ciphers() {
    local ciphers
    ciphers=$(sshd -T | grep ciphers | awk '{print $2}')

    for cipher in "${WEAK_CIPHERS[@]}"; do
        if [[ $ciphers == *"$cipher"* ]]; then
            echo "$TEST_ID:$TEST_TITLE:1:Weak cipher found $cipher"
            return 1
        fi
    done
    return 0
}

# Check for weak ciphers in SSH configuration
if ! check_weak_ciphers; then
    exit 1
fi

# If no weak ciphers found, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
