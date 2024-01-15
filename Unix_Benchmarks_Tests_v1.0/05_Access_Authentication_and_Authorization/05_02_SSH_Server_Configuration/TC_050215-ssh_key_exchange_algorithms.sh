#!/bin/bash
TEST_TITLE="Ensure only strong Key Exchange algorithms are used in SSH"
TEST_ID=050215
WEAK_KEX_ALGORITHMS=("diffie-hellman-group1-sha1" "diffie-hellman-group14-sha1" "diffie-hellman-group-exchange-sha1")

# Function to check for weak Key Exchange algorithms in SSH configuration
check_weak_kex() {
    local kex
    kex=$(sshd -T | grep kexalgorithms | awk '{print $2}')

    for algorithm in "${WEAK_KEX_ALGORITHMS[@]}"; do
        if [[ $kex == *"$algorithm"* ]]; then
            echo "$TEST_ID:$TEST_TITLE:1:Weak Key Exchange algorithm found $algorithm"
            return 1
        fi
    done
    return 0
}

# Check for weak Key Exchange algorithms in SSH configuration
if ! check_weak_kex; then
    exit 1
fi

# If no weak Key Exchange algorithms found, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
